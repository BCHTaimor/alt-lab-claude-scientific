# Design Patterns And Dependency Injection Guide

This guide is written to stand alone outside the original repository. It summarizes a practical pattern style for Python pipelines, especially scientific or data-processing projects.

The main architectural lesson is not "use every design pattern." It is "use a small number of patterns where they genuinely clarify extension points, shared state, and domain rules."

## 1. Strategy pattern for swappable decision logic

One of the strongest examples is the Strategy pattern.

The interface:

```python
from abc import ABC, abstractmethod

class ConfidenceStrategy(ABC):
    @abstractmethod
    def calculate_confidence(self, region_x_values, region_y_values, noise_amplitude_range):
        """
        @returns whether we think the region is C (Confident) or P (Putative)
        """
        pass
```

A concrete implementation:

```python
class SimpleThresholdConfidence(ConfidenceStrategy):
    def __init__(self, fork_max_minimum=0.15, minimum_points=10):
        self.fork_max_minimum = fork_max_minimum
        self.minimum_points = minimum_points

    def calculate_confidence(self, region_x_values, region_y_values, noise_amplitude_range):
        total_points = int(np.count_nonzero(np.abs(region_y_values) > noise_amplitude_range))
        max_fork = max(abs(region_y_values))

        if total_points >= self.minimum_points and max_fork > self.fork_max_minimum:
            return "C"
        return "P"
```

Another implementation:

```python
class AreaUnderCurveConfidence(ConfidenceStrategy):
    def __init__(self, x, y, gene_start=0, gene_end=1000, threshold_factor=0.03):
        self.threshold_factor = threshold_factor
        # compute baseline area for the whole gene region here

    def calculate_confidence(self, region_x_values, region_y_values, noise_amplitude_range):
        # compare area of this region to a threshold derived from the full gene region
        return "C" or "P"
```

Why this is strong:

- region segmentation code does not need to know how confidence is computed
- new scoring policies can be added independently
- tests can swap policies easily

## 2. Dependency injection through function parameters

The repo’s dependency injection style is lightweight and practical.

Example:

```python
def create_region_dict(
    x,
    y,
    boundary,
    confidence_strategy=None,
    debug_plotting=None,
):
    """
    Categorizes regions of the data based on crossing a specified boundary.
    """
    if confidence_strategy is None:
        confidence_strategy = SimpleThresholdConfidence()

    if debug_plotting is None:
        debug_plotting = []
```

What is being injected:

- `confidence_strategy`: the policy object that decides confidence
- `debug_plotting`: callback hooks for optional debugging behavior

Why this matters:

- the function is configurable without hard-coding one policy
- tests can inject custom collaborators
- the code stays plain Python without a DI framework

This is the key idea to carry into other repos: inject behavior through arguments when the behavior may vary.

## 3. Singleton pattern for shared run state

Two shared-state patterns are especially useful in pipeline code:

- one shared logger
- one shared data registry for run inputs and defaults

Example singleton logger shape:

```python
class SingletonLogger():
    class _Logger():
        def __init__(self, folder_path: str) -> None:
            self.file_name = os.path.join(folder_path, "log.log")

    instance = None

    def __new__(cls, folder_path: str = "logs"):
        if not SingletonLogger.instance:
            SingletonLogger.instance = SingletonLogger._Logger(folder_path)
        return SingletonLogger.instance
```

Example singleton registry shape:

```python
class SingletonDataRegistry:
    class _DataRegistry:
        def __init__(self):
            self.bdg_data = {}
            self.bed_data = {}
            self.defaults = []
            self.method = "zone"
            self.folder = "folder"

    instance = None

    def __new__(cls):
        if not SingletonDataRegistry.instance:
            SingletonDataRegistry.instance = SingletonDataRegistry._DataRegistry()
        return SingletonDataRegistry.instance
```

Why singletons fit this use case:

- many modules need the same run-level configuration
- a single log target simplifies observability
- pipeline code often has one active session at a time

Caution:

- this is appropriate for script-driven pipelines
- it is less appropriate for large concurrent service architectures
- singleton examples should document test-isolation and state-reset strategy clearly
- shared singleton state can leak across tests or parallel analyses if not reset deliberately

## 4. Interface-driven polymorphism for validators and loaders

Another useful pattern is defining a common interface for related file handlers.

Example:

```python
class BaseValidator(ABC):
    @abstractmethod
    def validate_path(self, path: str) -> bool:
        pass

    @abstractmethod
    def validate_name(self, path: str) -> bool:
        pass

    @abstractmethod
    def validate_structure(self, path: str) -> bool:
        pass


class BaseLoader(ABC):
    @abstractmethod
    def load_data(self, path: str) -> object:
        pass
```

Concrete implementations:

```python
class BedFileValidator(BaseValidator):
    def validate_path(self, path: str) -> bool:
        return os.path.isfile(path)

    def validate_name(self, path: str) -> bool:
        return path.endswith('.bed')

    def validate_structure(self, path: str):
        return pd.read_csv(path, sep="\t", usecols=[0, 1, 2, 3], header=None)


class BDGFileLoader(BaseLoader):
    def load_data(self, path: str) -> pd.DataFrame:
        # validate and then load
        return pd.read_csv(path, sep='\t', names=["Chromosome", "Start", "End", "Value"])
```

Why this is useful:

- each format has a predictable validation/loading shape
- callers can rely on consistent responsibilities
- new file types can be added without redesigning the whole module

## 5. Factory pattern: use the term carefully

This style does not require a formal `Factory` class everywhere.

What is often present instead:

- a family of related classes
- shared interfaces
- object construction chosen by context

Example family:

```python
class FileType:
    pass

class SignalFile(FileType):
    pass

class TerminationFile(FileType):
    pass

class WholeRegionFile(FileType):
    pass
```

That is factory-like in ecosystem shape, but not a formal factory pattern by itself.

So if you describe such a repo to another agent, be precise:

- say `strategy` when behavior is injected
- say `singleton` when one shared run instance exists
- say `abstract base class` or `interface-based polymorphism` when contracts are defined
- only say `factory` if there is an actual dedicated factory abstraction

## 6. Encapsulation, invariants, and rep-exposure protection

One strong design habit is to document object meaning and invariants directly in the class.

Example:

```python
class FileType():
    """
    AF(pattern) => creates filenames and can validate if a file name matches a particular pattern.
                    Also generates names for files made form combining files that match the pattern

    Rep Invarient:
        filenames created by generate_filename() pass the validation_function():

    Protection From rep exposure():
        the field pattern is never exposed in any functions
    """
```

Another strong move is returning deep copies from shared registries:

```python
def get_bdg_data(self):
    return copy.deepcopy(self.bdg_data)
```

Why this matters:

- callers are less likely to mutate shared internal state accidentally
- the class contract becomes easier to reason about

## 7. Pattern map you can reuse in future conversations

If you want to summarize this style to another agent, use this map:

- `Strategy`: swappable decision logic such as confidence scoring
- `Dependency injection`: injected strategy objects or callback hooks
- `Singleton`: shared run logger and data registry
- `Abstract base classes`: shared contracts for validators, loaders, and other extensible components
- `Factory-like class families`: multiple related implementations without necessarily having a formal factory class
- `Encapsulation with invariants`: documented abstraction functions and rep invariants for constrained classes

## 8. Practical guidance for other codebases

Use this pattern style when:

- you have multiple interchangeable scoring or classification rules
- you need one shared run configuration object
- you support several file formats with parallel validation/loading behavior
- you want testable extension points without heavy framework machinery

Avoid overusing it when:

- the project is tiny and only has one concrete behavior
- a singleton would make concurrent or multi-tenant execution unsafe
- abstract base classes would be more ceremony than value

## Summary

The most valuable patterns here are strategy, singleton, interface-based polymorphism, and lightweight dependency injection through parameters. The point is not pattern purity. The point is making extension points and shared responsibilities obvious.

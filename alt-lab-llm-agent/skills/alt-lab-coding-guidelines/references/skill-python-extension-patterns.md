# INFO

This skill teaches an AI assistant how to use Python extension patterns such as strategies, abstract interfaces, dependency injection, and shared-state objects in a practical way.

It is meant to teach pattern use as a tool for clarity, not as a reason to force every design pattern into every project.

# Skill: Python Extension Patterns

## Purpose

Use this skill when a Python codebase needs interchangeable behavior, shared run state, or clearly defined extension points.

## Core Idea

The goal is not “use every design pattern.” The goal is “use a small number of patterns where they genuinely clarify extension points, shared state, and domain rules.”

## Core Rules

### 1. Use strategy objects for swappable decision logic

Example interface:

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

Example implementation:

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

Why this is strong:

- the segmentation code does not need to know how confidence is computed
- new policies can be added independently
- tests can swap policies easily

### 2. Prefer lightweight dependency injection

Example:

```python
def create_region_dict(
    x,
    y,
    boundary,
    confidence_strategy=None,
    debug_plotting=None,
):
    if confidence_strategy is None:
        confidence_strategy = SimpleThresholdConfidence()

    if debug_plotting is None:
        debug_plotting = []
```

What is being injected:

- `confidence_strategy`
- `debug_plotting`

Why this matters:

- the function is configurable without hard-coding one policy
- tests can inject collaborators
- plain Python stays sufficient

### 3. Use singleton-like shared state cautiously

Example logger shape:

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

Example registry shape:

```python
class SingletonDataRegistry:
    class _DataRegistry:
        def __init__(self):
            self.bdg_data = {}
            self.bed_data = {}
            self.defaults = []
            self.method = "zone"
            self.folder = "folder"
```

Why this sometimes fits:

- many modules need the same run-level configuration
- one shared log target can simplify observability

Caution:

- shared state should document reset behavior
- test isolation matters
- concurrent analysis runs can be risky

### 4. Use abstract interfaces for validators and loaders

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
```

Why this is useful:

- every format shares a predictable contract
- new file types can be added cleanly

### 5. Be precise about pattern names

Use the correct label:

- `strategy` for swappable behavior
- `singleton` for one shared run instance
- `abstract base class` for shared contracts
- `factory` only when a dedicated factory abstraction truly exists

## Short Checklist

1. Is there a real extension point here?
2. Does the pattern make the code clearer?
3. Would a simpler function parameter do the job?
4. Is shared state documented and testable?
5. Am I naming the pattern accurately?

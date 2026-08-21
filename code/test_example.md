# when to write test case

write test cases for the public functions not the private, _function unless specifically asked.

integration test:

test cases over multiple function/classes specifically from differnet modules are integration test, usion

unit test:

test cases over 1 public function

# scope of test

partition over the relevant info, normally these means the parameters or special edge cases

"""
FileType():
    check_rep(): SignalFile, 
    validation_function(self, file): SignalFile, valid_filenames, invalid_filenames
"""

# unit test cases over a class

# class

class FileType():
    
    """
    AF(pattern) => creates filenames and can validate if a file name matches a particular pattern.
                    Also generates names for files made form combining files that match the pattern
    
    Rep Invarient:
        filenames created by generate_filename() pass the validation_function():
    
    Protection From rep exposure():
        the field pattern is never exposed in any functions
    """
    pattern: re.Pattern

    @classmethod
    def validation_function(self, file):
        """
        @param file (str): The file name to validate.
        @returns bool: True if the file matches the pattern, False utilswise.
        """
        pass

    @classmethod
    def generate_combined_filename(self):
        pass

    @classmethod
    def generate_filename():
        pass

    @classmethod
    def generate_example_filename():
        """
        @returns str: An example filename for testing or debugging.
        """
        pass

    def check_rep(self):
        example = self.generate_example_filename()
        assert self.validation_function(example), "FileType cannot be parsed by itself"
    
    @classmethod
    def get_name(self):
        pass

    def debug_self(self, text):
        """
        Tries to match the given text with the regex pattern and shows where the match fails.

        @param pattern (str): The regular expression pattern to match.
        @param text (str): The string to match the pattern against.
        """
        logger = SingletonLogger.get_logger()
  
        # Check if the match is found
        match = self.pattern.match(text)
        if match:
            print("Full match found:", match.groupdict())
            logger.info("Full match found:", match.groupdict())
            return

        pattern_str = self.pattern.pattern
        print(f"No full match found for pattern {self.get_name()}. Checking individual parts of the pattern: {self.pattern.pattern}")
        logger.error(f"No full match found for pattern {self.get_name()}. Checking individual parts of the pattern: {self.pattern.pattern}")
        split_text = text.split('_')
        for i, partial_pattern in enumerate(pattern_str.split('_')):
            if i >= len(split_text):
                break
            partial_regex = re.compile(partial_pattern)
            partial_match = partial_regex.match(split_text[i])
            if partial_match:
                print(f"Part '{partial_pattern}' matched: {split_text[i]}")
                logger.debug(f"Part '{partial_pattern}' matched: {split_text[i]}")
            else:
                print(f"Part '{partial_pattern}' failed to match: {split_text[i]}")
                logger.error(f"Part '{partial_pattern}' failed to match: {split_text[i]}")

class SignalFile(FileType):
    """
    example file: PTPRD_20240103_U2OS_DMSO_original.png
    get_name(): signal
    description: visual information across the whole gene showing one of three things: original data, fourier transform, the noise from said transform
    """

    pattern = re.compile(
        r"^(?P<gene>[A-Za-z0-9-]+)_"                 # Gene identifier (e.g., "BRCA1" or "GENE-1")
        r"(?P<sample>[A-Za-z0-9]+)_"                 # Sample identifier (e.g., "Sample1" or "U2OS")
        r"(?P<something>[A-Za-z0-9]+)_"              # Miscellaneous field (e.g., "X1" or "Region1")
        r"(?P<treatment>DMSO|APH)_"                  # Treatment (either "DMSO" or "APH")
        r"(?P<start>[+-]?[0-9]+)_"                   # Start +/- number
        r"(?P<end>[+-]?[0-9]+)_"                     # End +/- number
        r"(?P<category>noise|signal|original)\.png$" # Category (either "noise", "signal", or "original"), ending with ".png"
    )


    def validation_function(self, file):
        return bool(self.pattern.match(file))
    
    def generate_filename(self, gene, sample, something, treatment, start, end, category):
        """
        Generates a filename for an individual SignalData file. raises 

        @params gene (str): Gene identifier.
        @params sample (str): Sample identifier.
        @params something (str): An additional descriptor.
        @params treatment (str): treatment (e.g., DMSO or APH).
        @params category (str): Category (e.g., noise, signal, or original).
        @raises: raises a attribute error if the 
        @returns str: The generated filename as an example: SNTG1_20240103_U2OS_APH_noise.png
        """
        file_name = f'{gene}_{sample}_{something}_{treatment}_{start}_{end}_{category}.png'

        if not self.validation_function(file_name):
            self.debug_self(file_name)
            raise ValueError(f"No match found for pattern {self.pattern} in text {file_name}")
    
        return file_name
    
    def generate_example_filename(cls) -> str:
        return "SNTG1_20240103_U2OS_APH_6015488_12911759_noise.png"
    
    def get_name(self):
        return "signal"


# test cases 

"""
FileType():
    check_rep(): SignalFile, 
    validation_function(self, file): SignalFile, valid_filenames, invalid_filenames
"""

def test_FileType_SignalFile_validation_function():
    valid_filenames = [
        "SNTG1_20240103_U2OS_APH_10000_20000_noise.png",
        "GENE1_sample1_desc1_DMSO_10000_20000_signal.png"
    ]
    invalid_filenames = [
        "SNTG1_20240103_U2OS_APH_10000_2000.png",              # Missing category
        "SNTG1_20240103_U2OS_WRONG_1000_2000_noise.png",      # Invalid treatment
        "SNTG1_20240103_U2OS_APH_invalid.png",      # Invalid category
        "SNTG1_20240103__APH_noise.png",            # Extra underscore
        "SNTG1_20240103_U2OS_APH_noise.jpg",        # Wrong extension
        ""                                          # Empty string
    ]

    # Create an instance of SignalFile
    signal_file = SignalFile()

    # test valid filenames
    for filename in valid_filenames:
        result = signal_file.validation_function(filename)
        assert result, f"Valid filename '{filename}' failed validation"

    # test invalid filenames
    for filename in invalid_filenames:
        result = signal_file.validation_function(filename)
        assert not result, f"Invalid filename '{filename}' passed validation"

def test_FileType_SignalFile_generate_filename():
    valid_inputs = [
        ("BRCA1", "U20", "exon", "DMSO", "original"),
        ("TP53", "U20", "intron", "APH", "noise"),
        ("BRCA2", "U20", "exon", "APH", "signal")
    ]
    
    invalid_inputs = [
        ("", "sample_001", "exon", "chemutilsapy", "control"),        # Empty gene
        ("$", "sample_001", "exon", "chemutilsapy", "control"),       # Invalid gene (special char)
        ("BRCA1", "$sample", "exon", "chemutilsapy", "control"),      # Invalid sample (special char)
        ("BRCA1", "sample_001", "$something", "chemutilsapy", "control"),  # Invalid something (special char)
        ("BRCA1", "sample_001", "exon", "$treatment", "control"),     # Invalid treatment (special char)
        ("BRCA1", "sample_001", "exon", "chemutilsapy", "$category"), # Invalid category (special char)
        ("BRCA1", "sample_001", "exon", "chemutilsapy", "exp@rimental"),  # Invalid category (special char)
        ("BRCA1", "sample_001", "exon", "chemutilsapy", "experimental*"), # Invalid category (special char)
        ("BRCA1", "sample_001", "exon", "chemutilsapy", "experimental!") # Invalid category (special char)
    ]
    
    signal_maker = SignalFile()
    
    for gene, sample, something, treatment, category in valid_inputs:
        result = signal_maker.generate_filename(gene, sample, something, treatment, 10000, 20000, category)
        expected = f"{gene}_{sample}_{something}_{treatment}_10000_20000_{category}.png"
        assert result == expected, f"Valid inputs {gene}, {sample}, {something}, {treatment}, {category} failed. Got {result}"

    # test invalid inputs
    for gene, sample, something, treatment, category in invalid_inputs:
        with pytest.raises(ValueError) as exc_info:
            result = signal_maker.generate_filename(gene, sample, something, treatment, 10000, 20000, category)
        print(f"Invalid inputs {gene}, {sample}, {something}, {treatment}, {category} raised ValueError: {exc_info.value}")

def test_FileType_TerminationFile_validation_function():
    valid_filenames = [
        "PTPRD_20240618_U2OS_DMSO_6015488_12911759_signal.png",
        "PTPRD_20240103_U2OS_DMSO_6015488_12911759_signal.png"
    ]
    invalid_filenames = [
        "PTPRD_20240103_U2OS_DMSO_6015488_signal.png",        # Missing number
        "PTPRD_20240103_U2OS_UPS_6015488_12911759_signal.png",    # Invalid treatment
        "PTPRD_20240103_U2OS_DMSO_6015488_12911759_signal.jpg",     # Wrong extension
    ]

    termination_file = TerminationFile()

    for filename in valid_filenames:
        assert termination_file.validation_function(filename), f"Valid filename '{filename}' failed validation"

    for filename in invalid_filenames:
        assert not termination_file.validation_function(filename), f"invalid filename '{filename}' passed validation"


# unit test cases over a function

# function

def pad_interpolate(start, end, x, y, padding =2):
    """
    @param start, the start x-value
    @param end, the end x value
    @param x
    @param y
    @param padding, how far from start or end you can interpolate with
    @returns a new x,y in array as a tuple with the start and end added at correctly interpolated points

    #TODO I have no idea what this function does. Needs a much clearer explanation.
    I beleive that the problem is sometimes we want to get the area of a region where the region start and or end coords aren't actually 
    real points. like the boundaries of a gene coordinates. 
    so we need to interpolate points at that boundary based off the real points nearby just linear.

    """
    logger = SingletonLogger.get_logger()
    # step 0
    x_array = np.array(x)
    y_array = np.array(y)
    # start_index, end_index = find_closest_index_multiple_values(x_array,max(start-padding,0),end+padding)

    logical_array = np.logical_and(x_array >= max(start-padding,0), x_array <= end+padding)
    indices = np.where(logical_array == 1)[0]
    starting_index = indices[0] if indices.size > 0 else 0
    x_array = x_array[logical_array]
    y_array = y_array[logical_array]
    # special cases where 0 or 1 point
    if len(x_array) == 0:
        return np.array(x), np.array(y)
    if len(x_array) == 1:
        logger.debug("special 1 case")
        x_list = list(x)
        y_list = list(y)
        # Append start and end values to x
        if start < x_array[0]-padding:
            x_list.append(start)
            y_list.append(y_array[0])

        # Append corresponding y values and maintain order

        if end < x_array[-1]+padding:
            x_list.append(end)
            y_list.append(y_array[0])

        x_list.sort()  # Sort to maintain order
        y_list = [y for _, y in sorted(zip(x_list, y_list))]  # Sort y based on x order

        return np.array(x_list), np.array(y_list)

    # step 1
    x_start_index = -1
    x_end_index = -1
    start_indicator = 0
    end_indicator = 0
    for i, value in enumerate(x_array[:]):
        if i ==0:
            continue
        if x_array[i-1] == start:
            x_start_index = i-1
            y_start = x_array[i-1]
        if x_array[i] == start:
            x_start_index = i
            y_start = x_array[i]
        if x_array[i-1] == end:
            x_end_index = i-1
            y_end = x_array[i-1]
        if x_array[i] == end:
            x_end_index = i
            y_end = x_array[i-1]
        if x_array[i-1] < start < x_array[i]:
            start_indicator = 1
            x_start_index = i
            y_start = y_array[i-1]+(start-x_array[i-1])*(y_array[i]-y_array[i-1])/(x_array[i]-x_array[i-1])
        if x_array[i-1] < end < x_array[i]:
            end_indicator = 1
            x_end_index = i
            y_end = y_array[i]+(end-x_array[i])*(y_array[i]-y_array[i-1])/(x_array[i]-x_array[i-1])

    if start_indicator:
        pass
    if end_indicator:
        pass


    # step 3
    x_list = list(x)
    if start_indicator:
        x_list.insert(starting_index+x_start_index, start)
    if end_indicator:
        x_list.insert(starting_index+x_end_index+1*start_indicator, end)
    y_list = list(y)
    if start_indicator:
        y_list.insert(starting_index+x_start_index, y_start)
    if end_indicator:
        y_list.insert(starting_index+x_end_index+1*start_indicator, y_end)

    return np.array(x_list), np.array(y_list)

# test

def test_pad_interpolate_current():
    # both unreal start 
    x = [0,4]
    y = [0,4]
    start = 1
    end = 3
    expected_x = [0,1,3,4]
    expected_y = [0,1,3,4]
    result_x,result_y = pad_interpolate(start, end, x,y)
    assert np.array_equal(result_x, expected_x)
    assert np.array_equal(result_y, expected_y)

def test_pad_interpolate_greater_1_point():
    # both unreal start 
    x = [0,4]
    y = [0,4]
    start = 1
    end = 3
    expected_x = [0,1,3,4]
    expected_y = [0,1,3,4]
    result_x,result_y = pad_interpolate(start, end, x,y)
    assert np.array_equal(result_x, expected_x)
    assert np.array_equal(result_y, expected_y)

    # start real end unreal
    x = [0,4]
    y = [0,4]
    start = 0
    end = 3
    expected_x = [0,3,4]
    expected_y = [0,3,4]
    result_x,result_y = pad_interpolate(start, end, x,y)
    assert np.array_equal(result_x, expected_x)
    assert np.array_equal(result_y, expected_y)


    # start real end unreal
    x = [0,4]
    y = [0,4]
    start = 1
    end = 4
    expected_x = [0,1,4]
    expected_y = [0,1,4]
    result_x,result_y = pad_interpolate(start, end, x,y)
    assert np.array_equal(result_x, expected_x)
    assert np.array_equal(result_y, expected_y)

    # start real end real
    x = [0,4]
    y = [0,4]
    start = 0
    end = 4
    expected_x = [0,4]
    expected_y = [0,4]
    result_x,result_y = pad_interpolate(start, end, x,y)
    assert np.array_equal(result_x, expected_x)
    assert np.array_equal(result_y, expected_y)

def test_pad_interpolate_1_point():
    #TODO check this test case and fix any area_under curve issuses it causes
    x = [2]
    y = [4]
    start = 1
    end = 3
    expected_x = [2,3]
    expected_y = [4,4]
    result_x,result_y = pad_interpolate(start, end, x,y)
    assert np.array_equal(result_x, expected_x)
    assert np.array_equal(result_y, expected_y)

# def test_pad_interpolate_special_end_early_success():
#     x = [1,3,]
#     y = [4,2,]
#     start = 2
#     end = 4
#     expected_x = [1,2,3,4]
#     expected_y = [4,3,2,1]
#     result_x,result_y = pad_interpolate(start, end, x,y, padding =2)
#     assert np.array_equal(result_x, expected_x)
#     assert np.array_equal(result_y, expected_y)

def test_pad_interpolate_special_end_early():
    x = [1,3,]
    y = [4,2,]
    start = 2
    end = 4
    expected_x = [1,2,3,]
    expected_y = [4,3,2]
    result_x,result_y = pad_interpolate(start, end, x,y, padding =2)
    assert np.array_equal(result_x, expected_x)
    assert np.array_equal(result_y, expected_y)

    x = [1,3,7]
    y = [4,2,-10]
    start = 2
    end = 4
    expected_x = [1,2,3,7]
    expected_y = [4,3,2,-10]
    result_x,result_y = pad_interpolate(start, end, x,y, padding =2)
    assert np.array_equal(result_x, expected_x)
    assert np.array_equal(result_y, expected_y)

def test_pad_interpolate_special_start_soon():
    x = [3,5, 6,]
    y = [2,4,6,]
    start = 2
    end = 4
    expected_x = [3,4,5,6]
    expected_y = [2,3,4,6]
    result_x,result_y = pad_interpolate(start, end, x,y)
    assert np.array_equal(result_x, expected_x)
    assert np.array_equal(result_y, expected_y)

    x = [0,3,5, 6,]
    y = [20,2,4,6,]
    start = 2
    end = 4
    expected_x = [0,3,4,5,6]
    expected_y = [20,2,3,4,6]
    result_x,result_y = pad_interpolate(start, end, x,y,padding=1)
    assert np.array_equal(result_x, expected_x)
    assert np.array_equal(result_y, expected_y)
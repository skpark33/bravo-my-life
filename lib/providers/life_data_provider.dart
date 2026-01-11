import 'package:flutter/foundation.dart';
import '../models/life_data.dart';
import '../models/life_year.dart';
import '../services/storage_service.dart';
import '../utils/samjae_calculator.dart';

class LifeDataProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  LifeData? _lifeData;
  bool _isLoading = true;

  LifeData? get lifeData => _lifeData;
  bool get isLoading => _isLoading;

  // For the grid alignment
  // We need to know how many empty slots to put at the start of the first row
  // to make sure Samjae years align to the last 3 columns (indices 9, 10, 11).
  // Samjae years for a user are fixed zodiacs.
  // Example: Birth 1980 (Monkey). Samjae is Tiger(2), Rabbit(3), Dragon(4).
  // We want Tiger, Rabbit, Dragon to be at columns 10, 11, 12 (indices 9, 10, 11).
  // So column 12 (index 11) is Dragon(4).
  // Column 1 (index 0) must be Dragon(4) - 11 = -7. 4+12=16. 16-11=5 (Snake).
  // So the row always starts with Snake(5) for a Monkey born person?
  // Let's verify:
  // Col 1: Snake(5)
  // Col 2: Horse(6)
  // ...
  // Col 4: Monkey(8) -> This is the birth year 1980.
  // ...
  // Col 10: Tiger(2) -> Start Samjae
  // Col 11: Rabbit(3)
  // Col 12: Dragon(4) -> End Samjae. Correct.
  
  // So for any user, we find the "End Zoidac of Samjae".
  // The grid rows must start with (End Samjae Zodiac + 1) % 12.
  // Birth year's position in the first row is then determined by its zodiac relative to the row start zodiac.
  
  int get gridStartOffset {
    if (_lifeData == null) return 0;
    
    int birthYear = _lifeData!.birthYear;
    int birthZodiac = SamjaeCalculator.getZodiacIndex(birthYear);
    
    // Find Samjae End Zodiac
    int endSamjaeZodiac = -1;
     if ([8, 0, 4].contains(birthZodiac)) endSamjaeZodiac = 4; // Dragon
     else if ([5, 9, 1].contains(birthZodiac)) endSamjaeZodiac = 1; // Ox
     else if ([2, 6, 10].contains(birthZodiac)) endSamjaeZodiac = 10; // Dog
     else if ([11, 3, 7].contains(birthZodiac)) endSamjaeZodiac = 7; // Sheep
     
    int rowStartZodiac = (endSamjaeZodiac + 1) % 12;
    
    // Calculate offset of birth year from row start
    // (BirthZodiac - RowStartZodiac + 12) % 12
    return (birthZodiac - rowStartZodiac + 12) % 12;
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    
    _lifeData = await _storageService.loadData();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createNewData(int birthYear) async {
    _isLoading = true;
    notifyListeners();

    // Prepare 100 years of data
    Map<int, LifeYear> years = {};
    for (int i = 0; i <= 100; i++) {
      int y = birthYear + i;
      years[y] = LifeYear(year: y);
    }

    _lifeData = LifeData(birthYear: birthYear, years: years);
    await _storageService.saveData(_lifeData!);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateYear(LifeYear year) async {
    if (_lifeData == null) return;
    _lifeData!.years[year.year] = year;
    await _storageService.saveData(_lifeData!);
    notifyListeners();
  }

  Future<void> clearData() async {
    // Delete file logic if needed, or just save empty/null
    // _storageService.deleteFile(); 
    // Ideally StorageService should have delete.
    // For now we just reset in memory and maybe overwrite with empty?
    // Actually if we go back to Intro, we usually expect file to be gone.
    // I'll implement delete in StorageService.
    _lifeData = null;
    await _storageService.deleteData();
    notifyListeners();
  }
}

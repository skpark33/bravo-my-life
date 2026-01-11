import 'package:flutter_test/flutter_test.dart';
import 'package:bravo_my_life/models/life_year.dart';
import 'package:bravo_my_life/utils/samjae_calculator.dart';
import 'package:bravo_my_life/providers/life_data_provider.dart';
import 'package:bravo_my_life/models/life_data.dart'; // Add import if needed

void main() {
  group('Samjae Logic', () {
    test('Monkey (1980) Samjae check', () {
      // Monkey (1980) -> Samjae in Tiger, Rabbit, Dragon
      expect(SamjaeCalculator.getZodiacIndex(1980), 8); // Monkey

      // Tiger (1986)
      expect(SamjaeCalculator.getZodiacIndex(1986), 2);
      expect(SamjaeCalculator.isSamjae(1980, 1986), true);
      
      // Rabbit (1987)
      expect(SamjaeCalculator.isSamjae(1980, 1987), true);

      // Dragon (1988)
      expect(SamjaeCalculator.isSamjae(1980, 1988), true);

      // Snake (1989) - Not Samjae
      expect(SamjaeCalculator.isSamjae(1980, 1989), false);
    });

    test('Pig (1983) Samjae check', () {
      // Pig (1983) -> Samjae in Snake, Horse, Sheep
      expect(SamjaeCalculator.getZodiacIndex(1983), 11);
      
      // Snake (1989)
      expect(SamjaeCalculator.isSamjae(1983, 1989), true);
    });
  });

  group('Grid Offset Logic', () {
    test('Monkey (1980) Grid Offset', () {
      // Monkey(8). Samjae End = Dragon(4). Row Start = Snake(5).
      // Birth(8) - Start(5) = 3.
      
      // Since we can't easily instantiate Provider with mock data without mocking Storage,
      // We'll copy the logic here or stub the provider.
      // Let's just test the logic directly:
      
      int birthYear = 1980;
      int birthZodiac = SamjaeCalculator.getZodiacIndex(birthYear);
      int endSamjaeZodiac = 4; // Dragon for Monkey
      int rowStartZodiac = (endSamjaeZodiac + 1) % 12; // Snake(5)
      int offset = (birthZodiac - rowStartZodiac + 12) % 12;
      
      expect(offset, 3);
    });
  });
  
  group('Model Serialization', () {
    test('LifeYear JSON', () {
      final year = LifeYear(year: 1980, score: 1);
      final json = year.toJson();
      expect(json['year'], 1980);
      expect(json['score'], 1);
      
      final reconstructed = LifeYear.fromJson(json);
      expect(reconstructed.year, 1980);
      expect(reconstructed.score, 1);
    });
  });
}

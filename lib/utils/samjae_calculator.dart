class SamjaeCalculator {
  // 0: Rat, 1: Ox, 2: Tiger, 3: Rabbit, 4: Dragon, 5: Snake
  // 6: Horse, 7: Sheep, 8: Monkey, 9: Rooster, 10: Dog, 11: Pig
  
  static int getZodiacIndex(int year) {
    // 4 AD was Rat(0). (2020 - 4) % 12 = 0.
    int offset = 4;
    return (year - offset) % 12; 
  }

  static bool isSamjae(int birthYear, int targetYear) {
    int birthZodiac = getZodiacIndex(birthYear);
    int targetZodiac = getZodiacIndex(targetYear);

    // Monkey(8), Rat(0), Dragon(4) -> Samjae: Tiger(2), Rabbit(3), Dragon(4)
    if ([8, 0, 4].contains(birthZodiac)) {
      return [2, 3, 4].contains(targetZodiac);
    }
    // Snake(5), Rooster(9), Ox(1) -> Samjae: Pig(11), Rat(0), Ox(1)
    if ([5, 9, 1].contains(birthZodiac)) {
      return [11, 0, 1].contains(targetZodiac);
    }
    // Tiger(2), Horse(6), Dog(10) -> Samjae: Monkey(8), Rooster(9), Dog(10)
    if ([2, 6, 10].contains(birthZodiac)) {
      return [8, 9, 10].contains(targetZodiac);
    }
    // Pig(11), Rabbit(3), Sheep(7) -> Samjae: Snake(5), Horse(6), Sheep(7)
    if ([11, 3, 7].contains(birthZodiac)) {
      return [5, 6, 7].contains(targetZodiac);
    }
    
    return false;
  }
  
  // Helper to check what kind of Samjae it is (Entering, Staying, Leaving)
  // Samjae lasts 3 years.
  // 1st year: Entering (Deul-Samjae)
  // 2nd year: Staying (Nul-Samjae)
  // 3rd year: Leaving (Nal-Samjae)
  static String? getSamjaeType(int birthYear, int targetYear) {
    if (!isSamjae(birthYear, targetYear)) return null;
    
    // Determine the start year of the Samjae cycle for this birth zodiac
    // Logic: Samjae always occurs in specific zodiac years.
    // e.g. for Monkey/Rat/Dragon, Samjae is Tiger(2), Rabbit(3), Dragon(4).
    // Tiger is the start.
    
    int birthZodiac = getZodiacIndex(birthYear);
    int targetZodiac = getZodiacIndex(targetYear);
    
    int startZodiac = -1;
     if ([8, 0, 4].contains(birthZodiac)) startZodiac = 2;
     else if ([5, 9, 1].contains(birthZodiac)) startZodiac = 11;
     else if ([2, 6, 10].contains(birthZodiac)) startZodiac = 8;
     else if ([11, 3, 7].contains(birthZodiac)) startZodiac = 5;
     
     // Calculate relative position
     // Handle wrapping for Pig(11) -> Rat(0) -> Ox(1)
     int diff = (targetZodiac - startZodiac + 12) % 12;
     
     if (diff == 0) return 'Entering'; // Deul-Samjae
     if (diff == 1) return 'Staying'; // Nul-Samjae
     if (diff == 2) return 'Leaving'; // Nal-Samjae
     
     return null;
  }
}

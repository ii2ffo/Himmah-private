class FoodItem {
  const FoodItem({
    required this.name,
    required this.serving,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.category,
  });

  final String name;
  final String serving;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final String category;
}

const foodCatalog = <FoodItem>[
  FoodItem(name: 'صدر دجاج مشوي', serving: '100 جم', calories: 165, protein: 31, carbs: 0, fat: 4, category: 'بروتين'),
  FoodItem(name: 'لحم بقري قليل الدهن', serving: '100 جم', calories: 190, protein: 26, carbs: 0, fat: 9, category: 'بروتين'),
  FoodItem(name: 'بيض كامل', serving: 'حبة كبيرة', calories: 72, protein: 6, carbs: 1, fat: 5, category: 'بروتين'),
  FoodItem(name: 'حليب عالي البروتين', serving: 'عبوة', calories: 230, protein: 34, carbs: 18, fat: 3, category: 'مشروبات'),
  FoodItem(name: 'أرز أبيض مطبوخ', serving: '100 جم', calories: 130, protein: 3, carbs: 28, fat: 0, category: 'كارب'),
  FoodItem(name: 'بطاطس مشوية', serving: '100 جم', calories: 149, protein: 3, carbs: 27, fat: 4, category: 'كارب'),
  FoodItem(name: 'خبز تنور', serving: 'رغيف متوسط', calories: 230, protein: 7, carbs: 46, fat: 2, category: 'كارب'),
  FoodItem(name: 'شوفان', serving: '50 جم', calories: 190, protein: 7, carbs: 32, fat: 4, category: 'كارب'),
  FoodItem(name: 'زبادي يوناني', serving: '170 جم', calories: 120, protein: 17, carbs: 8, fat: 2, category: 'ألبان'),
  FoodItem(name: 'جبنة فيتا', serving: '30 جم', calories: 80, protein: 4, carbs: 1, fat: 6, category: 'ألبان'),
  FoodItem(name: 'موز', serving: 'حبة متوسطة', calories: 105, protein: 1, carbs: 27, fat: 0, category: 'فواكه'),
  FoodItem(name: 'تفاح', serving: 'حبة متوسطة', calories: 95, protein: 0, carbs: 25, fat: 0, category: 'فواكه'),
  FoodItem(name: 'تمر', serving: '3 حبات', calories: 70, protein: 1, carbs: 19, fat: 0, category: 'فواكه'),
  FoodItem(name: 'سلطة خضراء', serving: 'طبق متوسط', calories: 90, protein: 3, carbs: 14, fat: 3, category: 'خضار'),
  FoodItem(name: 'برقر لحم منزلي', serving: '100 جم', calories: 250, protein: 24, carbs: 2, fat: 17, category: 'وجبات'),
  FoodItem(name: 'ساندويتش كبدة', serving: 'ساندويتش', calories: 420, protein: 25, carbs: 43, fat: 17, category: 'وجبات'),
];

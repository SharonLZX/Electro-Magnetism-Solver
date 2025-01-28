final List<String> inputs = ['B', 'BD', 'S', 'SD', 'A', 'P', 'dFlux', 'dt'];
final List<String> xyzPlane = ["x", "y", "z"];

final List<String> formulaList = [
  'Magnetic Flux Integral (ΦB = ∫∫B·dS)',
  'Induced EMF in a loop (E = - dΦB/dt)',
];

final List<RegExp> regexList = [
  RegExp(r'^(x|y|z|xy|yx|xz|zx|yz|zy)$'),
  RegExp(r'^(a|ax|ay|az)$'),
  RegExp(r'^[a-zA-Z0-9+\-*/()]*\^?\d*$'),
  RegExp(r'^[a-zA-Z0-9+\-*/%=()^]+$'),
];

final RegExp coefficientRegEx = RegExp(r'([-+]?\d+)\s*([a-zA-Z]+\(x\)|x)');

final List<String> superscriptDigits = [
  '⁰',
  '¹',
  '²',
  '³',
  '⁴',
  '⁵',
  '⁶',
  '⁷',
  '⁸',
  '⁹'
];

final List<String> subscriptDigits = [
  '₀',
  '₁',
  '₂',
  '₃',
  '₄',
  '₅',
  '₆',
  '₇',
  '₈',
  '₉'
];

const String planeHint = 'Plane (e.g. xy, yx, xz, etc.)';
const String magFieldHint = 'B (Magnetic Field Strength in Tesla)';
const String fieldDirecHint = 'Field direction (ax, ay, az):';
const String surfAreaHint = 'S (Surface Area in m²):';
const String surfDirecHint = 'Surface direction (ax, ay, az):';
const String chgMagFluxHint = 'dΦB (Change in Magnetic Flux in Weber)';
const String chgTimeHint = 'dt (Change in Time in seconds)';
const List<String> arithOper1 = ["/", "*"];
const List<String> arithOper2 = ["+", "-"];




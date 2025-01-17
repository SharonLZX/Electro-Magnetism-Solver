List<String> formulaList = [
  'Magnetic Flux Integral (ΦB = ∫∫B·dS)',
  'Induced EMF in a loop (E = - dΦB/dt)',
];

const List<String> superscriptDigits = [
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
const List<String> subscriptDigits = [
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

final List<String>inputs = ['B', 'BD', 'S', 'SD', 'A', 'P', 'dFlux', 'dt'];
const List<String> xyzPlane = ["x", "y", "z"];

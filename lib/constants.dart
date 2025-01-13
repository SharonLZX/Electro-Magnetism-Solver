final List<String> formulaList = [
  'Magnetic Flux Integral (ΦB = ∫∫B·dS)',
  'Induced EMF in a loop (E = - dΦB/dt)',
];

const inputs = ['B', 'BD', 'S', 'SD', 'A', 'P', 'dFlux', 'dt'];

const String planeFormHint = 'Plane (e.g. xy, yx, xz, etc.)';
const String magFieldHint = 'B (Magnetic Field Strength in Tesla)';
const String fieldDirecHint = 'Field direction (ax, ay, az):';
const String surAreaHint = 'S (Surface Area in m²):';
const String surDirecHint = 'Surface direction (ax, ay, az):';
const String chgMagFluxHint = 'dΦB (Change in Magnetic Flux in Weber)';
const String chgTimeHint = 'dt (Change in Time in seconds)';

int sqrt(int value) {
  return value * value;
}

Future<BigInt> factorial(BigInt number) async {
  if (number <= BigInt.one) {
    return BigInt.one;
  } else {
    return (number * await factorial(number - BigInt.one));
  }
}

Future<BigInt> power(BigInt base, BigInt a) async {
  if (a != BigInt.zero) {
    return (base * await power(base, a - BigInt.one));
  } else {
    return BigInt.one;
  }
}

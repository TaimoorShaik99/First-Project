public class MathUtility {
    public static Integer add(Integer num1, Integer num2) {
        return num1 + num2;
    }
 
    public static Integer subtract(Integer num1, Integer num2) {
        return num1 - num2;
    }
 
    public static Integer multiply(Integer num1, Integer num2) {
        return num1 * num2;
    }
 
    public static Decimal divide(Integer num1, Integer num2) {
        if (num2 == 0) {
            throw new MathException('Division by zero is not allowed.');
        }
 
        return num1 / num2;
    }
 
    public static Integer modulus(Integer num1, Integer num2) {
        if (num2 == 0) {
            throw new MathException('Modular division by zero is not allowed.');
        }
        return Math.mod(num1, num2);
    }
}
public class MathUtility {
    
    // Addition
    public static Integer add(Integer num1, Integer num2) {
        return num1 + num2;
    }
    
    // Subtraction
    public static Integer subtract(Integer num1, Integer num2) {
        return num1 - num2;
    }
    
    // Multiplication
    public static Integer multiply(Integer num1, Integer num2) {
        return num1 * num2;
    }
    
    // Division with error handling
    public static Integer divide(Integer num1, Integer num2) {
        if (num2 == 0) {
           throw new MathException('Division by zero is not allowed');
        }
        return num1 / num2;
    }
    
    // Modulo operation with error handling
    public static Integer modulo(Integer num1, Integer num2) {
        if (num2 == 0) {
            throw new MathException('Modulo by zero is not allowed');
        }
        return Math.mod(num1, num2);
    }
}

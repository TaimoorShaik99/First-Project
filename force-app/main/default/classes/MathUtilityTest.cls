@isTest
public class MathUtilityTest {
    @isTest
    public static void testAddition() {
        Integer result = MathUtility.add(10, 5);
        System.assertEquals(15, result, 'Addition failed');
    }
    @isTest
    public static void testSubtraction() {
        Integer result = MathUtility.subtract(10, 5);
        System.assertEquals(5, result, 'Subtraction failed');
    }
    @isTest
    public static void testMultiplication() {
        Integer result = MathUtility.multiply(10, 5);
        System.assertEquals(50, result, 'Multiplication failed');
    }
    @isTest
    public static void testDivision() {
        Decimal result = MathUtility.divide(10, 2);
        System.assertEquals(5, result, 'Division failed');
    }
    @isTest
    public static void testDivisionByZero() {
            MathUtility.divide(10, 0);
            System.assert(false, 'Expected exception was not thrown.');
   
    }
    @isTest
    public static void testModulus() {
        Integer result = MathUtility.modulus(10, 3);
        System.assertEquals(1, result, 'Modulus calculation failed');
    }
    @isTest
    public static void testModulusByZero() {
            MathUtility.modulus(10, 0);
            System.assert(false, 'Expected exception was not thrown.');
       
    }
}
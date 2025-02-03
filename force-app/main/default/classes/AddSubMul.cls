public class AddSubMul {
 
    public static void addSubMul(){
        
        Integer a=10;
  	    Integer b=20;
        
        system.debug(a+b);
        system.debug(a-b);
        system.debug(a*b);
    }
    
    public static void listMethod(){
        List<Integer> li = new List<Integer>();
        li.add(10);
        li.add(20);
        li.add(30);
        li.add(40);
        li.add(50);
        system.debug(li);
        system.debug(li.size());
        system.debug(li.get(3));
    }
}
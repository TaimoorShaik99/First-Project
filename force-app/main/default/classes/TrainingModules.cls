public class TrainingModules {

     String name='Conscendo';
     Integer age=3;
    
    public String location;
    public Integer distance;
    public boolean active;
    
    public void details(){
        system.debug(name);
        system.debug(age);
    }
    
    public void comLoc(){
        system.debug(location);
        system.debug(distance);
        system.debug(active);
    }
}
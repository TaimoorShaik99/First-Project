import { LightningElement } from 'lwc';

export default class ParentComponent extends LightningElement {
    // The parent can include other logic or call functions, but in this example,
    // it is just rendering the greeting component.
    class Counter {
        constructor() {
            this.count = 0;  // Initial count
        }
    
        // Increment the counter
        increment() {
            this.count++;
            this.displayCount();
        }
    
        // Decrement the counter
        decrement() {
            if (this.count > 0) {
                this.count--;
            } else {
                console.log("Count cannot be negative");
            }
            this.displayCount();
        }
    
        // Display current count
        displayCount() {
            console.log("Current Count: " + this.count);
        }
    }
    
    // Create a new Counter object
    const myCounter = new Counter();
    
    // Increment the counter by 1
    myCounter.increment(); // Current Count: 1
    
    // Increment the counter by 1
    myCounter.increment(); // Current Count: 2
    
    // Decrement the counter by 1
    myCounter.decrement(); // Current Count: 1
    
    // Decrement the counter by 1
    myCounter.decrement(); // Current Count: 0
    
    // Attempt to decrement below zero
    myCounter.decrement(); // "Count cannot be negative"
    
}

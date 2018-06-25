package aName.contracts.datatypes;

import aName.contracts.datatypes.CompTypeAllPrimitives;
import aName.contracts.datatypes.CompTypeEmpty;
import aName.contracts.datatypes.CompTypeCollTypesPrimitive;
		
public class CompTypeCompTypes {
	
	private CompTypeEmpty compTypeEmpty;
	private CompTypeAllPrimitives compTypeAllPrimitives;
	private CompTypeCollTypesPrimitive compTypeCollTypesPrimitive;
	
	public CompTypeCompTypes() {
		// TODO: Implement and verify auto-generated constructor.
		this.compTypeEmpty = new CompTypeEmpty();
		this.compTypeAllPrimitives = new CompTypeAllPrimitives();
		this.compTypeCollTypesPrimitive = new CompTypeCollTypesPrimitive();
	}
	
	public CompTypeCompTypes(CompTypeEmpty compTypeEmpty, CompTypeAllPrimitives compTypeAllPrimitives, CompTypeCollTypesPrimitive compTypeCollTypesPrimitive) {
		// TODO: Implement and verify auto-generated constructor.
		this.compTypeEmpty = compTypeEmpty;
		this.compTypeAllPrimitives = compTypeAllPrimitives;
		this.compTypeCollTypesPrimitive = compTypeCollTypesPrimitive;
	}
	
	public CompTypeEmpty getCompTypeEmpty() {
	    return compTypeEmpty;
	}
	
	public void setCompTypeEmpty(CompTypeEmpty compTypeEmpty) {
	    this.compTypeEmpty = compTypeEmpty;
	}
	
	public CompTypeAllPrimitives getCompTypeAllPrimitives() {
	    return compTypeAllPrimitives;
	}
	
	public void setCompTypeAllPrimitives(CompTypeAllPrimitives compTypeAllPrimitives) {
	    this.compTypeAllPrimitives = compTypeAllPrimitives;
	}
	
	public CompTypeCollTypesPrimitive getCompTypeCollTypesPrimitive() {
	    return compTypeCollTypesPrimitive;
	}
	
	public void setCompTypeCollTypesPrimitive(CompTypeCollTypesPrimitive compTypeCollTypesPrimitive) {
	    this.compTypeCollTypesPrimitive = compTypeCollTypesPrimitive;
	}
	
}
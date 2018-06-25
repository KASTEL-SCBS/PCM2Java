package aName.contracts.datatypes;

import java.lang.Iterable;
import java.util.ArrayList;
import aName.contracts.datatypes.CompTypeAllPrimitives;
		
public class CompTypeFull extends CompTypeInheritance {
	
	private int primInt;
	private String primString;
	private CompTypeAllPrimitives compTypeAllPrimitives;
	private Iterable<Object> collTypeEmpty;
	private Iterable<Iterable<Object>> collTypeCollTypeEmpty;
	
	public CompTypeFull() {
		// TODO: Implement and verify auto-generated constructor.
		this.primString = "";
		this.compTypeAllPrimitives = new CompTypeAllPrimitives();
		this.collTypeEmpty = new ArrayList<Object>();
		this.collTypeCollTypeEmpty = new ArrayList<Iterable<Object>>();
	}
	
	public CompTypeFull(int primInt, String primString, CompTypeAllPrimitives compTypeAllPrimitives, Iterable<Object> collTypeEmpty, Iterable<Iterable<Object>> collTypeCollTypeEmpty) {
		// TODO: Implement and verify auto-generated constructor.
		this.primInt = primInt;
		this.primString = primString;
		this.compTypeAllPrimitives = compTypeAllPrimitives;
		this.collTypeEmpty = collTypeEmpty;
		this.collTypeCollTypeEmpty = collTypeCollTypeEmpty;
	}
	
	public int getPrimInt() {
	    return primInt;
	}
	
	public void setPrimInt(int primInt) {
	    this.primInt = primInt;
	}
	
	public String getPrimString() {
	    return primString;
	}
	
	public void setPrimString(String primString) {
	    this.primString = primString;
	}
	
	public CompTypeAllPrimitives getCompTypeAllPrimitives() {
	    return compTypeAllPrimitives;
	}
	
	public void setCompTypeAllPrimitives(CompTypeAllPrimitives compTypeAllPrimitives) {
	    this.compTypeAllPrimitives = compTypeAllPrimitives;
	}
	
	public Iterable<Object> getCollTypeEmpty() {
	    return collTypeEmpty;
	}
	
	public void setCollTypeEmpty(Iterable<Object> collTypeEmpty) {
	    this.collTypeEmpty = collTypeEmpty;
	}
	
	public Iterable<Iterable<Object>> getCollTypeCollTypeEmpty() {
	    return collTypeCollTypeEmpty;
	}
	
	public void setCollTypeCollTypeEmpty(Iterable<Iterable<Object>> collTypeCollTypeEmpty) {
	    this.collTypeCollTypeEmpty = collTypeCollTypeEmpty;
	}
	
}
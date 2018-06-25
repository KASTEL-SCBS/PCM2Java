package aName.contracts.datatypes;

import java.lang.Iterable;
import java.util.ArrayList;
import aName.contracts.datatypes.CompTypeEmpty;
		
public class CompTypeCollTypesComplex {
	
	private Iterable<Iterable<Object>> collTypeCollTypeEmpty;
	private Iterable<CompTypeEmpty> collTypeCompTypeEmpty;
	private Iterable<Iterable<CompTypeEmpty>> collTypeCollTypeCompTypeEmpty;
	private Iterable<Iterable<Iterable<CompTypeEmpty>>> collTypeCollTypeCollTypeCompTypeEmpty;
	
	public CompTypeCollTypesComplex() {
		// TODO: Implement and verify auto-generated constructor.
		this.collTypeCollTypeEmpty = new ArrayList<Iterable<Object>>();
		this.collTypeCompTypeEmpty = new ArrayList<CompTypeEmpty>();
		this.collTypeCollTypeCompTypeEmpty = new ArrayList<Iterable<CompTypeEmpty>>();
		this.collTypeCollTypeCollTypeCompTypeEmpty = new ArrayList<Iterable<Iterable<CompTypeEmpty>>>();
	}
	
	public CompTypeCollTypesComplex(Iterable<Iterable<Object>> collTypeCollTypeEmpty, Iterable<CompTypeEmpty> collTypeCompTypeEmpty, Iterable<Iterable<CompTypeEmpty>> collTypeCollTypeCompTypeEmpty, Iterable<Iterable<Iterable<CompTypeEmpty>>> collTypeCollTypeCollTypeCompTypeEmpty) {
		// TODO: Implement and verify auto-generated constructor.
		this.collTypeCollTypeEmpty = collTypeCollTypeEmpty;
		this.collTypeCompTypeEmpty = collTypeCompTypeEmpty;
		this.collTypeCollTypeCompTypeEmpty = collTypeCollTypeCompTypeEmpty;
		this.collTypeCollTypeCollTypeCompTypeEmpty = collTypeCollTypeCollTypeCompTypeEmpty;
	}
	
	public Iterable<Iterable<Object>> getCollTypeCollTypeEmpty() {
	    return collTypeCollTypeEmpty;
	}
	
	public void setCollTypeCollTypeEmpty(Iterable<Iterable<Object>> collTypeCollTypeEmpty) {
	    this.collTypeCollTypeEmpty = collTypeCollTypeEmpty;
	}
	
	public Iterable<CompTypeEmpty> getCollTypeCompTypeEmpty() {
	    return collTypeCompTypeEmpty;
	}
	
	public void setCollTypeCompTypeEmpty(Iterable<CompTypeEmpty> collTypeCompTypeEmpty) {
	    this.collTypeCompTypeEmpty = collTypeCompTypeEmpty;
	}
	
	public Iterable<Iterable<CompTypeEmpty>> getCollTypeCollTypeCompTypeEmpty() {
	    return collTypeCollTypeCompTypeEmpty;
	}
	
	public void setCollTypeCollTypeCompTypeEmpty(Iterable<Iterable<CompTypeEmpty>> collTypeCollTypeCompTypeEmpty) {
	    this.collTypeCollTypeCompTypeEmpty = collTypeCollTypeCompTypeEmpty;
	}
	
	public Iterable<Iterable<Iterable<CompTypeEmpty>>> getCollTypeCollTypeCollTypeCompTypeEmpty() {
	    return collTypeCollTypeCollTypeCompTypeEmpty;
	}
	
	public void setCollTypeCollTypeCollTypeCompTypeEmpty(Iterable<Iterable<Iterable<CompTypeEmpty>>> collTypeCollTypeCollTypeCompTypeEmpty) {
	    this.collTypeCollTypeCollTypeCompTypeEmpty = collTypeCollTypeCollTypeCompTypeEmpty;
	}
	
}
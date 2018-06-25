package aName.contracts.datatypes;

import java.lang.Iterable;
import java.util.ArrayList;
		
public class CompTypeCollTypesPrimitive {
	
	private Iterable<Object> collTypeEmpty;
	private Iterable<Boolean> collTypeBoolean;
	private Iterable<Byte> collTypeByte;
	private Iterable<Character> collTypeChar;
	private Iterable<Integer> collTypeInt;
	private Iterable<Long> collTypeLong;
	private Iterable<Double> collTypeDouble;
	private Iterable<String> collTypeString;
	
	public CompTypeCollTypesPrimitive() {
		// TODO: Implement and verify auto-generated constructor.
		this.collTypeEmpty = new ArrayList<Object>();
		this.collTypeBoolean = new ArrayList<Boolean>();
		this.collTypeByte = new ArrayList<Byte>();
		this.collTypeChar = new ArrayList<Character>();
		this.collTypeInt = new ArrayList<Integer>();
		this.collTypeLong = new ArrayList<Long>();
		this.collTypeDouble = new ArrayList<Double>();
		this.collTypeString = new ArrayList<String>();
	}
	
	public CompTypeCollTypesPrimitive(Iterable<Object> collTypeEmpty, Iterable<Boolean> collTypeBoolean, Iterable<Byte> collTypeByte, Iterable<Character> collTypeChar, Iterable<Integer> collTypeInt, Iterable<Long> collTypeLong, Iterable<Double> collTypeDouble, Iterable<String> collTypeString) {
		// TODO: Implement and verify auto-generated constructor.
		this.collTypeEmpty = collTypeEmpty;
		this.collTypeBoolean = collTypeBoolean;
		this.collTypeByte = collTypeByte;
		this.collTypeChar = collTypeChar;
		this.collTypeInt = collTypeInt;
		this.collTypeLong = collTypeLong;
		this.collTypeDouble = collTypeDouble;
		this.collTypeString = collTypeString;
	}
	
	public Iterable<Object> getCollTypeEmpty() {
	    return collTypeEmpty;
	}
	
	public void setCollTypeEmpty(Iterable<Object> collTypeEmpty) {
	    this.collTypeEmpty = collTypeEmpty;
	}
	
	public Iterable<Boolean> getCollTypeBoolean() {
	    return collTypeBoolean;
	}
	
	public void setCollTypeBoolean(Iterable<Boolean> collTypeBoolean) {
	    this.collTypeBoolean = collTypeBoolean;
	}
	
	public Iterable<Byte> getCollTypeByte() {
	    return collTypeByte;
	}
	
	public void setCollTypeByte(Iterable<Byte> collTypeByte) {
	    this.collTypeByte = collTypeByte;
	}
	
	public Iterable<Character> getCollTypeChar() {
	    return collTypeChar;
	}
	
	public void setCollTypeChar(Iterable<Character> collTypeChar) {
	    this.collTypeChar = collTypeChar;
	}
	
	public Iterable<Integer> getCollTypeInt() {
	    return collTypeInt;
	}
	
	public void setCollTypeInt(Iterable<Integer> collTypeInt) {
	    this.collTypeInt = collTypeInt;
	}
	
	public Iterable<Long> getCollTypeLong() {
	    return collTypeLong;
	}
	
	public void setCollTypeLong(Iterable<Long> collTypeLong) {
	    this.collTypeLong = collTypeLong;
	}
	
	public Iterable<Double> getCollTypeDouble() {
	    return collTypeDouble;
	}
	
	public void setCollTypeDouble(Iterable<Double> collTypeDouble) {
	    this.collTypeDouble = collTypeDouble;
	}
	
	public Iterable<String> getCollTypeString() {
	    return collTypeString;
	}
	
	public void setCollTypeString(Iterable<String> collTypeString) {
	    this.collTypeString = collTypeString;
	}
	
}
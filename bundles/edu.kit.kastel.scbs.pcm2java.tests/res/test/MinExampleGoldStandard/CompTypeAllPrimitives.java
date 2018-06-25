package aName.contracts.datatypes;

public class CompTypeAllPrimitives {
	
	private boolean primBoolean;
	private byte primByte;
	private char primChar;
	private int primInt;
	private long primLong;
	private double primDouble;
	private String primString;
	
	public CompTypeAllPrimitives() {
		// TODO: Implement and verify auto-generated constructor.
		this.primString = "";
	}
	
	public CompTypeAllPrimitives(boolean primBoolean, byte primByte, char primChar, int primInt, long primLong, double primDouble, String primString) {
		// TODO: Implement and verify auto-generated constructor.
		this.primBoolean = primBoolean;
		this.primByte = primByte;
		this.primChar = primChar;
		this.primInt = primInt;
		this.primLong = primLong;
		this.primDouble = primDouble;
		this.primString = primString;
	}
	
	public boolean getPrimBoolean() {
	    return primBoolean;
	}
	
	public void setPrimBoolean(boolean primBoolean) {
	    this.primBoolean = primBoolean;
	}
	
	public byte getPrimByte() {
	    return primByte;
	}
	
	public void setPrimByte(byte primByte) {
	    this.primByte = primByte;
	}
	
	public char getPrimChar() {
	    return primChar;
	}
	
	public void setPrimChar(char primChar) {
	    this.primChar = primChar;
	}
	
	public int getPrimInt() {
	    return primInt;
	}
	
	public void setPrimInt(int primInt) {
	    this.primInt = primInt;
	}
	
	public long getPrimLong() {
	    return primLong;
	}
	
	public void setPrimLong(long primLong) {
	    this.primLong = primLong;
	}
	
	public double getPrimDouble() {
	    return primDouble;
	}
	
	public void setPrimDouble(double primDouble) {
	    this.primDouble = primDouble;
	}
	
	public String getPrimString() {
	    return primString;
	}
	
	public void setPrimString(String primString) {
	    this.primString = primString;
	}
	
}
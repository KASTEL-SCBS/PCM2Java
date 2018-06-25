package edu.kit.kastel.scbs.pcm2java.tests;

public enum TestFileName {
	
	BASIC_COMPONENT_DIAMOND("BasicComponentDiamond"),
	BASIC_COMPONENT_EMPTY("BasicComponentEmpty"),
	BASIC_COMPONENT_FULL("BasicComponentFull"),
	BASIC_COMPONENT_MULT_PROV_ROLE("BasicComponentMultProvRole"),
	BASIC_COMPONENT_MULT_REQ_ROLE("BasicComponentMultReqRole"),
	BASIC_COMPONENT_SINGLE_PROV_ROLE("BasicComponentSingleProvRole"), 	
	BASIC_COMPONENT_SINGLE_REQ_ROLE("BasicComponentSingleReqRole"),
	COMP_TYPE_ALL_PRIMITIVES("CompTypeAllPrimitives"),
	COMP_TYPE_COLL_TYPES_COMPLEX("CompTypeCollTypesComplex"),
	COMP_TYPE_COLL_TYPES_PRIMITIVE("CompTypeCollTypesPrimitive"),
	COMP_TYPE_COMP_TYPES("CompTypeCompTypes"),
	COMP_TYPE_EMPTY("CompTypeEmpty"),
	COMP_TYPE_FULL("CompTypeFull"),
	COMP_TYPE_INHERITANCE("CompTypeInheritance"),
	OP_INTERFACE_COMPLEX_TYPES("OpInterfaceComplexTypes"),
	OP_INTERFACE_DIAMOND("OpInterfaceDiamond"),
	OP_INTERFACE_EMPTY("OpInterfaceEmpty"),
	OP_INTERFACE_FULL("OpInterfaceFull"),
	OP_INTERFACE_INHERITANCE_MULT("OpInterfaceInheritanceMult"),
	OP_INTERFACE_INHERITANCE_ONE("OpInterfaceInheritanceOne"),
	OP_INTERFACE_INHERITANCE_TWO("OpInterfaceInheritanceTwo"),
	OP_INTERFACE_PRIMITIVE_TYPES("OpInterfacePrimitiveTypes");
	

	
	public final String fileName;
	
	TestFileName(String fileName) {
		this.fileName = fileName;
	}
}

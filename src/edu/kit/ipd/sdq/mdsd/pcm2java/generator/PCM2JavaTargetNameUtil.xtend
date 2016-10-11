package edu.kit.ipd.sdq.mdsd.pcm2java.generator

import org.palladiosimulator.pcm.repository.PrimitiveTypeEnum
import org.palladiosimulator.pcm.repository.PrimitiveDataType
import org.palladiosimulator.pcm.core.entity.NamedElement
import org.palladiosimulator.pcm.repository.Repository
import org.eclipse.emf.ecore.EObject

import static extension edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorConstants.*
import org.palladiosimulator.pcm.repository.CompositeDataType
import org.palladiosimulator.pcm.repository.OperationInterface
import org.palladiosimulator.pcm.repository.BasicComponent

/**
 * A utility class for getting target names during PCM2Java code generation
 * 
 */
class PCM2JavaTargetNameUtil {
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	static def dispatch String getTargetName(EObject object, boolean pkg) {
		throw new UnsupportedGeneratorInput("determine a target " + if (pkg) "package" else "folder" + " name", object)
	}
		
	static def dispatch String getTargetName(NamedElement namedElement, boolean pkg) {
		return namedElement.entityName
	}
	
	static def dispatch String getTargetName(CompositeDataType dataType, boolean pkg) {
		return getContractsTargetPrefix(dataType.repository__DataType, pkg) + getSeparator(pkg) + getDataTypesTargetName() + getSeparatorAtEnd(pkg)
	}
	
	static def dispatch String getTargetName(OperationInterface iface, boolean pkg) {
		return getContractsTargetPrefix(iface.repository__Interface, pkg) + getSeparator(pkg) + getInterfacesTargetName() + getSeparatorAtEnd(pkg)
	}
	
	static def dispatch String getTargetName(BasicComponent bc, boolean pkg) {
		return getComponentsTargetPrefix(bc.repository__RepositoryComponent, pkg) + getSeparator(pkg) + bc.entityName + getSeparatorAtEnd(pkg)
	}
	
	static def dispatch String getTargetName(PrimitiveDataType pdt, boolean pkg) {
		switch pdt.getType() {
			case PrimitiveTypeEnum::STRING : "s"
			default : ""
		}
	}
	
	static def String getContractsTargetPrefix(Repository repo, boolean pkg) {
		return getRepoTargetPrefix(repo, pkg) + getSeparator(pkg) + getContractsTargetName()
	}
	
	static def String getRepoTargetPrefix(Repository repo, boolean pkg) {
		return (if (pkg) "" else getTargetFolderPrefix()) + getTargetName(repo, pkg)
	}
	
	static def String getComponentsTargetPrefix(Repository repo, boolean pkg) {
		return getRepoTargetPrefix(repo, pkg) + getSeparator(pkg) + getComponentsTargetName()
	}
	
	static def dispatch String getTargetFileName(EObject object) {
		throw new UnsupportedGeneratorInput("determine a target file name", object)
	}
	
	static def dispatch String getTargetFileName(NamedElement namedElement) {
		return namedElement.entityName.toFirstUpper
	}
	
	static def dispatch String getTargetFileName(PrimitiveDataType pdt) {
		switch pdt.getType() {
			case PrimitiveTypeEnum::STRING : "String"
			case PrimitiveTypeEnum::INT: "int"
			case PrimitiveTypeEnum::BOOL: "boolean"
			case PrimitiveTypeEnum::DOUBLE: "double"
			case PrimitiveTypeEnum::BYTE: "byte"
			case PrimitiveTypeEnum::CHAR: "char"
			default : ""
		}
	}
	
	static def dispatch String getTargetFileName(Void v) '''void'''
}
package edu.kit.ipd.sdq.mdsd.pcm2java.generator

import java.util.ArrayList
import java.util.HashSet
import org.eclipse.emf.ecore.EObject
import org.palladiosimulator.pcm.core.entity.InterfaceProvidingEntity
import org.palladiosimulator.pcm.core.entity.NamedElement
import org.palladiosimulator.pcm.repository.BasicComponent
import org.palladiosimulator.pcm.repository.CollectionDataType
import org.palladiosimulator.pcm.repository.CompositeDataType
import org.palladiosimulator.pcm.repository.DataType
import org.palladiosimulator.pcm.repository.OperationInterface

import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorConstants.*
import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorUtil.*
import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaTargetNameUtil.*
import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCMUtil.*

final class PCM2JavaGeneratorHeadAndImports {
	
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	static def String generateImportsAndClassHead(NamedElement namedElement) {
		return generateImportsAndClassifierHead(namedElement,"class")
	}
	
	static def String generateImportsAndInterfaceHead(NamedElement namedElement) {
		return generateImportsAndClassifierHead(namedElement,"interface")
	}
	
	static def String generateImportsAndClassifierHead(NamedElement namedElement, String classifierType) {
		val packageDeclaration = generatePackageDeclaration(namedElement)
		val imports = generateImports(namedElement)
		val classifierName = namedElement.entityName
		val classifierHead = generateClassifierHeader(classifierType, classifierName)
		return packageDeclaration + imports + classifierHead
	}
	
	private static def String generatePackageDeclaration(NamedElement element) {
		return "package " + getTargetName(element, true) + ''';

'''
	}
	
	private static def String generateClassifierHeader(String classifierType, String classifierName) '''
	public «classifierType» «classifierName» '''
	
	private static def String generateImports(NamedElement namedElement) {
		var imports = ""
		var elementsToImport = getElementsToImport(namedElement)
		for (elementToImport : elementsToImport) {
			imports += generateImport(elementToImport)
		}
		return imports + if (imports.equals("")) "" else '''
		
'''
	}
	
	private static def dispatch Iterable<? extends EObject> getElementsToImport(NamedElement namedElement) {
		throw new UnsupportedGeneratorInput("generate imports for", namedElement)
	}
	
	private static def dispatch Iterable<Object> getElementsToImport(CompositeDataType dataType) {
		val elementsToImport = new ArrayList<Object>
		elementsToImport.addAll(dataType.innerDeclaration_CompositeDataType.map[it.datatype_InnerDeclaration].dataTypesToImport)
		return elementsToImport
	}
	
	private static def Iterable<Object> getDataTypesToImport(Iterable<DataType> dataTypes) {
		val dataTypesToImport = new HashSet<Object>
		dataTypesToImport.addAll(dataTypes.filter(CompositeDataType))
		if (dataTypes.filter(CollectionDataType).length != 0) {
			dataTypesToImport.add(Iterable)
			dataTypesToImport.add(ArrayList)
		}
		dataTypesToImport.addAll(getInnerTypes(dataTypes.filter(CollectionDataType)).filter(CompositeDataType))
		return dataTypesToImport
	}
	
	private static def dispatch Iterable<Object> getElementsToImport(OperationInterface iface) {
		return getTypesUsedInSignaturesOfProvidedServices(iface)
	}
	
	private static def Iterable<Object> getTypesUsedInSignaturesOfProvidedServices(OperationInterface iface) {
		val usedTypes =  new HashSet<Object>
		for (providedSignature : iface.signatures__OperationInterface) {
			usedTypes.addAll(getDataTypesToImport(#{providedSignature.returnType__OperationSignature}))
			usedTypes.addAll(getDataTypesToImport(providedSignature.parameters__OperationSignature.map[it.dataType__Parameter]))
		}
		usedTypes.remove(ArrayList) //ArrayList not needed if collection data type is only used in signature
		return usedTypes
	}
	
	private static def dispatch Iterable<Object> getElementsToImport(BasicComponent bc) {
		val elementsToImport = new HashSet<Object>()
		elementsToImport.addAll(getProvidedInterfaces(bc))
		elementsToImport.addAll(getRequiredInterfaces(bc))
		elementsToImport.addAll(bc.typesUsedInSignaturesOfProvidedServices)
		for (iface : getAllInheritedOperationInterfaces(bc)) {
			elementsToImport.addAll(iface.typesUsedInSignaturesOfProvidedServices) // 
		}
		return elementsToImport
	}
	
	private static def Iterable<Object> getTypesUsedInSignaturesOfProvidedServices(InterfaceProvidingEntity ipe) {
		val usedTypes = new HashSet<Object>()
		for (providedInterface : getProvidedInterfaces(ipe)) {
			usedTypes.addAll(getTypesUsedInSignaturesOfProvidedServices(providedInterface))
		}
		return usedTypes
	}

	private static dispatch def String generateImport(EObject eObject) {
		val fullyQualifiedTypeToImport = getTargetName(eObject, true) + getSeparator(true) + getTargetFileName(eObject)
		return generateImport(fullyQualifiedTypeToImport)
	}
	
	private static dispatch def String generateImport(String fullyQualifiedTypeToImport) '''import «fullyQualifiedTypeToImport»;
	'''
	
	private static dispatch def String generateImport(Class<?> c) '''import «c.name»;
	'''
	
}
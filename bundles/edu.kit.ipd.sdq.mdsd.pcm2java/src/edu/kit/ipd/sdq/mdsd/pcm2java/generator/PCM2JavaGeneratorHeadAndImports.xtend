package edu.kit.ipd.sdq.mdsd.pcm2java.generator

import java.util.ArrayList
import java.util.HashSet
import org.eclipse.emf.ecore.EObject
import org.palladiosimulator.pcm.core.entity.InterfaceProvidingEntity
import org.palladiosimulator.pcm.repository.BasicComponent
import org.palladiosimulator.pcm.repository.CollectionDataType
import org.palladiosimulator.pcm.repository.CompositeDataType
import org.palladiosimulator.pcm.repository.DataType
import org.palladiosimulator.pcm.repository.OperationInterface

import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorConstants.*

import static extension edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.core.entity.CollectionDataTypeUtil.*
import static extension edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.core.entity.InterfaceProvidingEntityUtil.*
import static extension edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.core.entity.InterfaceRequiringEntityUtil.*
import static extension edu.kit.ipd.sdq.commons.util.org.palladiosimulator.pcm.repository.BasicComponentUtil.*
import static extension edu.kit.ipd.sdq.mdsd.pcm2java.util.PCM2JavaTargetNameUtil.*
import org.palladiosimulator.pcm.core.entity.Entity

/**
 *  This class is used to generate imports and a head in Java source code for PCM entities.
 */
class PCM2JavaGeneratorHeadAndImports {

 	private Entity entity // the entity for which code is currently being generated 
	
	/**
	 * Generates all necessary import statements and a class head in Java source code for the given PCM entity.
	 * The given entity must be a PCM operation interface, basic component or composite data type.
	 * 
	 * @param entity the entity for which source code should be generated
	 * @return the generated import statements and a class head
	 */
	def String generateImportsAndClassHead(Entity entity) {
		this.entity = entity
		return generateImportsAndClassifierHead("class")
	}
	
	/**
	 * Generates all necessary import statements and a interface head in Java source code for the given PCM entity.
	 * The given entity must be a PCM operation interface, basic component, or composite data type.
	 * 
	 * @param entity the entity for which source code should be generated
	 * @return the generated import statements and interface head
	 */
	def String generateImportsAndInterfaceHead(Entity entity) {
		this.entity = entity
		return generateImportsAndClassifierHead("interface")
	}
	
	/**
	 * Generates all necessary import statements and a class or interface head in Java source code for the currently processed PCM entity.
	 * The given string determines the type (e.g. class or interface) of the generated source code.
	 * 
	 * @param classifierType classifier type of the generated Java code
	 * @return the generated import statements and head
	 */
	private def String generateImportsAndClassifierHead(String classifierType) {
		val packageDeclaration = generatePackageDeclaration()
		val imports = generateImports()
		val classifierName = entity.entityName
		val classifierHead = generateClassifierHeader(classifierType, classifierName)
		return packageDeclaration + imports + classifierHead
	}
	
	/**
	 * Generates a package declaration for the currently processed entity.
	 * 
	 * @return the generated package declaration
	 */
	private def String generatePackageDeclaration() {
		return "package " + getTargetName(entity, true) + ''';

'''
	}
	
	/**
	 * Generates a head for the currently processed entity.
	 * The given string determines the type (e.g. class or interface) of the generated source code.
	 * 
	 * @param classifierType classifier type of the generated Java code
	 * @return the generated head
	 */
	private def String generateClassifierHeader(String classifierType, String classifierName) '''
	public «classifierType» «classifierName» '''
	
	/**
	 * Generates all necessary import statements for the currently processed entity.
	 * 
	 * @returnthe generated imports
	 */
	private def String generateImports() {
		var imports = ""
		var elementsToImport = getElementsToImport(entity)
		for (elementToImport : elementsToImport) {
			imports += generateImport(elementToImport)
		}
		return imports + if (imports.equals("")) "" else '''
		
'''
	}
	
	/**
	 * Returns all necessary elements to import for the given entity.
	 * The given entity should be a PCM composite data type, - operation interface, or - basic component.
	 * 
	 * @param entity a PCM entity
	 * @return an iterable object consisting of all elements that are necessary to import
	 * @throws UnsupportedGeneratorInput if it is not possible to generate the necessary imports for the given entity
	 */
	def dispatch Iterable<? extends EObject> getElementsToImport(Entity entity) {
		throw new UnsupportedGeneratorInput("can't generate imports for", entity)
	}
	
	/**
	 * Returns all necessary elements to import for the given entity.
	 * The given entity should be a PCM composite data type, - operation interface, or - basic component.
	 * 
	 * @param entity a PCM entity
	 * @return an iterable object consisting of all elements that are necessary to import
	 * @throws UnsupportedGeneratorInput if it is not possible to generate the necessary imports for the given entity
	 */
	def dispatch Iterable<Object> getElementsToImport(CompositeDataType dataType) {
		val elementsToImport = new ArrayList<Object>
		elementsToImport.addAll(dataType.innerDeclaration_CompositeDataType.map[it.datatype_InnerDeclaration].dataTypesToImport)
		return elementsToImport
	}
	
	/**
	 * Returns all types that are necessary to import if all data types in that are given are used.
	 * This means that the returned iterable object contains all composite data types that are given but no primitive data types.
	 * If there are collection data types given Iterable and ArrayList as well as the inner types will also be returned.
	 * 
	 * @param dataTypes PCM data types that are used
	 * @return all types that must be imported
	 */
	private def Iterable<Object> getDataTypesToImport(Iterable<DataType> dataTypes) {
		val dataTypesToImport = new HashSet<Object>
		dataTypesToImport.addAll(dataTypes.filter(CompositeDataType))
		if (dataTypes.filter(CollectionDataType).length != 0) {
			dataTypesToImport.add(Iterable)
			dataTypesToImport.add(ArrayList)
		}
		dataTypesToImport.addAll(dataTypes.filter(CollectionDataType).getInnerTypes.filter(CompositeDataType))
		return dataTypesToImport
	}
	
	/**
	 * Returns all necessary elements to import for the given entity.
	 * The given entity should be a PCM composite data type, - operation interface, or - basic component.
	 * 
	 * @param entity a PCM entity
	 * @return an iterable object of types that are necessary to import
	 * @throws UnsupportedGeneratorInput if it is not possible to generate the necessary imports for the given entity
	 */
	def dispatch Iterable<Object> getElementsToImport(OperationInterface iface) {
		return getTypesUsedInSignaturesOfProvidedServices(iface)
	}
	
	/**
	 * Returns all types that are used in the signatures of the provided services of a given operation interface and are necessary to import.
	 * (e.g. no primitive data types)
	 * 
	 * @param iface a PCM operation interface
	 * @return an iterable object containing all types that must be imported
	 */
	private def Iterable<Object> getTypesUsedInSignaturesOfProvidedServices(OperationInterface iface) {
		val usedTypes =  new HashSet<Object>
		for (providedSignature : iface.signatures__OperationInterface) {
			usedTypes.addAll(getDataTypesToImport(#{providedSignature.returnType__OperationSignature}))
			usedTypes.addAll(getDataTypesToImport(providedSignature.parameters__OperationSignature.map[it.dataType__Parameter]))
		}
		usedTypes.remove(ArrayList) //ArrayList not needed if collection data type is only used in signature
		return usedTypes
	}
	
	/**
	 * Returns all necessary elements to import for the given entity.
	 * The given entity should be a PCM composite data type, - operation interface, or - basic component.
	 * 
	 * @param entity a PCM entity
	 * @return an iterable object of elements that are necessary to import
	 * @throws UnsupportedGeneratorInput if it is not possible to generate the necessary imports for the given entity
	 */
	def dispatch Iterable<Object> getElementsToImport(BasicComponent bc) {
		val elementsToImport = new HashSet<Object>()
		elementsToImport.addAll(bc.getProvidedInterfaces)
		elementsToImport.addAll(bc.getRequiredInterfaces)
		elementsToImport.addAll(bc.typesUsedInSignaturesOfProvidedServices)
		for (iface : bc.getAllInheritedOperationInterfaces) {
			elementsToImport.addAll(iface.typesUsedInSignaturesOfProvidedServices)
		}
		return elementsToImport
	}
	
	/**
	 * Returns all types that are used in the signatures of any provided interface of a given interface providing entity that are necessary to import.
	 * (e.g. no primitive data types)
	 * 
	 * @param ipe a PCM interface providing entity
	 * @return an iterable object containing all types that must be imported
	 */
	private def Iterable<Object> getTypesUsedInSignaturesOfProvidedServices(InterfaceProvidingEntity ipe) {
		val usedTypes = new HashSet<Object>()
		for (providedInterface : ipe.getProvidedInterfaces) {
			usedTypes.addAll(getTypesUsedInSignaturesOfProvidedServices(providedInterface))
		}
		return usedTypes
	}

	/**
	 * Generates an import statement.
	 * The returned string starts with "import " followed by the fully qualified type of the given object and ends with a semicolon.
	 * 
	 * @param eObject an eObject
	 * @return the generated import statement
	 */
	private dispatch def String generateImport(EObject eObject) {
		val fullyQualifiedTypeToImport = eObject.getTargetName(true) + getSeparator(true) + eObject.getTargetFileName
		return generateImport(fullyQualifiedTypeToImport)
	}
	
	/**
	 * Generates an import statement.
	 * The returned string starts with "import " followed by the given fully qualified type and ends with a semicolon.
	 * 
	 * @param fullyQualifiedTypeToImport the fully qualified type for which an import statement should be generated
	 * @return the generated import statement
	 */
	private dispatch def String generateImport(String fullyQualifiedTypeToImport) '''import «fullyQualifiedTypeToImport»;
	'''
	
	/**
	 * Generates an import statement.
	 * The returned string starts with "import " followed by the name of the given class and ends with a semicolon.
	 * 
	 * @param c the class for which an import statement should be generated
	 * @return the generated import statement
	 */
	private dispatch def String generateImport(Class<?> c) '''import «c.name»;
	'''
	
}
package edu.kit.ipd.sdq.mdsd.pcm2java.generator

import edu.kit.ipd.sdq.commons.ecore2txt.generator.AbstractEcore2TxtGenerator
import java.util.ArrayList
import java.util.HashSet
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.internal.xtend.util.Triplet
import org.palladiosimulator.pcm.core.entity.InterfaceProvidingEntity
import org.palladiosimulator.pcm.core.entity.NamedElement
import org.palladiosimulator.pcm.repository.BasicComponent
import org.palladiosimulator.pcm.repository.CollectionDataType
import org.palladiosimulator.pcm.repository.CompositeDataType
import org.palladiosimulator.pcm.repository.DataType
import org.palladiosimulator.pcm.repository.InnerDeclaration
import org.palladiosimulator.pcm.repository.OperationInterface
import org.palladiosimulator.pcm.repository.OperationProvidedRole
import org.palladiosimulator.pcm.repository.OperationSignature
import org.palladiosimulator.pcm.repository.PrimitiveDataType
import tools.vitruv.framework.util.bridges.EcoreBridge

import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorConstants.*
import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaTargetNameUtil.*
import static edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCMUtil.*

class PCM2JavaGeneratorOld extends AbstractEcore2TxtGenerator {
		
	private static final String newLine = System.lineSeparator()	
		
	override getFolderNameForResource(Resource inputResource) throws UnsupportedOperationException {
		throw new UnsupportedOperationException()
	}
	
	override getFileNameForResource(Resource inputResource) throws UnsupportedOperationException {
		throw new UnsupportedOperationException()
	}
	
	override postProcessGeneratedContents(String contents) {
		// no postprocessing: do nothing
		return contents
	}

	override generateContentsFromResource(Resource inputResource) {
		val contentsForFolderAndFileNames = new ArrayList<Triplet<String,String,String>>()
		generateAndAddContents(inputResource, contentsForFolderAndFileNames)
		return contentsForFolderAndFileNames
	}
	
	private def void generateAndAddContents(Resource inputResource, List<Triplet<String,String,String>> contentsForFolderAndFileNames) {
		for (element : EcoreBridge.getAllContents(inputResource)) {
			val content = generateContent(element)
			if (content != null && !content.equals("")) {
				val folderName = getTargetName(element, false)
				val fileName = getTargetFileName(element) + getTargetFileExt()
				val contentAndFileName = new Triplet<String,String,String>(content,folderName,fileName) 
				contentsForFolderAndFileNames.add(contentAndFileName)
			}
		}
	}
	
	def dispatch String generateContent(EObject object) {
//		"Cannot generate content for generic EObject '" + object + "'!"
		return ""
	}
	
	def dispatch String generateContent(CompositeDataType dataType) {
		val importsAndClassifierHead = generateImportsAndClassHead(dataType)
		val extendsRelations = generateExtendsRelation(dataType)
		val fields = generateFields(dataType)
		val constructor = generateConstructor(dataType)
		val methods = generateMethods(dataType)
		return importsAndClassifierHead + extendsRelations + '''{
	«fields»
	
	«constructor»
	
	«methods»
}'''
	}
		
	private def generateExtendsRelation(CompositeDataType dataType) '''«
	FOR parent : dataType.parentType_CompositeDataType
		BEFORE 'extends '
		»«parent.entityName» «
	ENDFOR»'''	
		
	private def generateFields(CompositeDataType dataType) '''«
	FOR declaration : dataType.innerDeclaration_CompositeDataType
		BEFORE newLine
		SEPARATOR newLine
		»private «declaration.innerDeclarationClassName» «declaration.entityName»;«
	ENDFOR»''' 
	
	private def generateConstructor(CompositeDataType dataType) '''
	public «dataType.entityName»() {
		// TODO: Implement and verify auto-generated constructor.
		«FOR declaration : dataType.nonPrimitiveDeclarations
			»this.«declaration.entityName» = «generateConstructorCall(declaration.datatype_InnerDeclaration)»«
		ENDFOR»
	}
	'''
	
	private def generateMethods(CompositeDataType dataType) '''«
		FOR declaration : dataType.innerDeclaration_CompositeDataType
			SEPARATOR newLine
			AFTER newLine
		»«generateGetterSetter(declaration)
		»«ENDFOR
	»'''
	
	private def generateGetterSetter(InnerDeclaration declaration) '''«
	»public «declaration.innerDeclarationClassName» get«declaration.entityName.toFirstUpper»() {
«   »    return «declaration.entityName»;
«   »}

«
	»public void set«declaration.entityName.toFirstUpper»(«declaration.innerDeclarationClassName» «declaration.entityName») {
«   »    this.«declaration.entityName» = «declaration.entityName»;
«   »}
'''
		
	private dispatch def String generateConstructorCall(CompositeDataType dataType) {
		return '''new «dataType?.classNameOfDataType»();«newLine»'''
	}
	
	private dispatch def String generateConstructorCall(CollectionDataType dataType) {
		val innerType = dataType.innerType_CollectionDataType
		if (innerType != null) {
			return '''new ArrayList<«dataType.innerType_CollectionDataType.classNameOfDataType.primitiveToReferenceName»>();«newLine»'''
		} else {
			return '''new ArrayList<Object>();«newLine»'''
		}
	}
	
	private dispatch def String generateConstructorCall(PrimitiveDataType dataType) throws UnsupportedOperationException {
		switch (dataType.type) {
			case STRING : '''"";'''
			default: throw new UnsupportedOperationException("Can only generate constructor calls for primitive type String: " + dataType.type)
		}
	}
		
	private dispatch def String generateConstructorCall(DataType dataType) throws UnsupportedOperationException {
		throw new UnsupportedOperationException("Can only generate constructor calls for String, collection- or composite data types " + dataType.class.toString)
	}
		
	def dispatch String generateContent(OperationInterface iface) {
		val importsAndClassifierHead = generateImportsAndInterfaceHead(iface)
		val extendsRelations = generateExtendsRelations(iface)
		val methodDeclarations = generateMethodDeclarations(iface.signatures__OperationInterface)
		return importsAndClassifierHead + extendsRelations + '''{
			
	«methodDeclarations»

}'''
	}	
		
	def generateMethodDeclarations(Iterable<OperationSignature> operationSignatures) '''«
		
		FOR operationSignature : operationSignatures 
			SEPARATOR "; " + newLine
			AFTER "; " + newLine
			»«generateMethodDeclarationWithoutSemicolon(operationSignature)»«
		ENDFOR 
	»'''
	
	private def String generateImportsAndInterfaceHead(NamedElement namedElement) {
		return generateImportsAndClassifierHead(namedElement,"interface")
	}
	
	private def generateExtendsRelations(OperationInterface iface) '''«
	FOR providedInterface : iface.allInheritedOperationInterfaces
		BEFORE 'extends '
		SEPARATOR ', '
		AFTER ' '
		»«providedInterface.entityName»«
	ENDFOR»'''
	
	private def String generateMethodDeclarationWithoutSemicolon(OperationSignature operationSignature) {
				val returnType = operationSignature.returnType__OperationSignature.generateReturnType
				val methodName = getMethodName(operationSignature)
				val parameterDeclarations = '''«
				FOR parameter : operationSignature.parameters__OperationSignature
					SEPARATOR ', '
»«parameter.dataType__Parameter.classNameOfDataType» «getParameterName(parameter)»«
				ENDFOR»'''
				return '''«returnType» «methodName»(«parameterDeclarations»)'''
	}
	
	private def String generateReturnType(DataType returnType) {
		if (returnType != null) {
			return returnType.classNameOfDataType
		}
		return "void"
	} 
	
	def dispatch String generateContent(BasicComponent bc) {
		val importsAndClassifierHead = generateImportsAndClassHead(bc)
		val implementsRelations = generateImplementsRelations(bc)
		val fields = generateFields(bc)
		val constructor = generateConstructor(bc)
		val methods = generateMethodDefinitions(bc)
		
		return importsAndClassifierHead + implementsRelations + '''{
	«fields»
	
	«constructor»
	
	«methods»
}'''	
	}
	
	private def generateMethodDefinitions(BasicComponent bc) {
		var methodDefinitions = generateMethodDefinitions(bc.providedRoles_InterfaceProvidingEntity.filter(OperationProvidedRole).map[it.providedInterface__OperationProvidedRole].map[it.signatures__OperationInterface].flatten).toString
		val inheritedInterfaces = bc.allInheritedOperationInterfaces
		for (iface : inheritedInterfaces) {
			methodDefinitions += generateMethodDefinitions(iface.signatures__OperationInterface)
		}
		return methodDefinitions
	}
	
	private def generateMethodDefinitions(Iterable<OperationSignature> operationSignatures) '''«
		FOR operationSignature : operationSignatures 
			SEPARATOR '{
	// TODO: implement and verify auto-generated method stub
	throw new UnsupportedOperationException("TODO: auto-generated method stub");
}

'
			AFTER '{
	// TODO: implement and verify auto-generated method stub
	throw new UnsupportedOperationException("TODO: auto-generated method stub");
}

'
	»public «generateMethodDeclarationWithoutSemicolon(operationSignature)»«
		ENDFOR 
	»
	'''
		
	private def generateImplementsRelations(BasicComponent bc) '''«
	FOR providedInterface : getProvidedInterfaces(bc)
		BEFORE 'implements '
		SEPARATOR ', '
		AFTER ' '
		»«providedInterface.entityName»«
	ENDFOR»'''
	
	private def generateFields(BasicComponent bc) '''«
	FOR iface : getRequiredInterfaces(bc)
		BEFORE '
'
		SEPARATOR '
'
		»private «iface.entityName» «iface.entityName.toFirstLower»;«
	ENDFOR»''' 
	
	private def generateConstructor(BasicComponent bc) '''
	public «bc.entityName»(«
	FOR iface2 : getRequiredInterfaces(bc)
		SEPARATOR ", "
		»«iface2.entityName» «iface2.entityName.toFirstLower
	»«ENDFOR») {
		// TODO: implement and verify auto-generated constructor.
	«FOR iface : getRequiredInterfaces(bc)
		»    this.«iface.entityName.toFirstLower» = «iface.entityName.toFirstLower»;
    «ENDFOR»
	}'''
	
	private def String generateImportsAndClassHead(NamedElement namedElement) {
		return generateImportsAndClassifierHead(namedElement,"class")
	}
	
	private def String generateImportsAndClassifierHead(NamedElement namedElement, String classifierType) {
		val packageDeclaration = generatePackageDeclaration(namedElement)
		val imports = generateImports(namedElement)
		val classifierName = namedElement.entityName
		val classifierHead = generateClassifierHeader(classifierType, classifierName)
		return packageDeclaration + imports + classifierHead
	}
	
	private def String generatePackageDeclaration(NamedElement element) {
		return "package " + getTargetName(element, true) + ''';

'''
	}
	
	private def String generateClassifierHeader(String classifierType, String classifierName) '''
	public «classifierType» «classifierName» '''
	
	private def String generateImports(NamedElement namedElement) {
		var imports = ""
		var elementsToImport = getElementsToImport(namedElement)
		for (elementToImport : elementsToImport) {
			imports += generateImport(elementToImport)
		}
		return imports + if (imports.equals("")) "" else '''
		
'''
	}
	
	private def dispatch Iterable<? extends EObject> getElementsToImport(NamedElement namedElement) {
		throw new UnsupportedGeneratorInput("generate imports for", namedElement)
	}
	
	private def dispatch Iterable<Object> getElementsToImport(CompositeDataType dataType) {
		val elementsToImport = new ArrayList<Object>
		elementsToImport.addAll(dataType.innerDeclaration_CompositeDataType.map[it.datatype_InnerDeclaration].dataTypesToImport)
		return elementsToImport
	}
	
	private def Iterable<Object> getDataTypesToImport(Iterable<DataType> dataTypes) {
		val dataTypesToImport = new HashSet<Object>
		dataTypesToImport.addAll(dataTypes.filter(CompositeDataType))
		if (dataTypes.filter(CollectionDataType).length != 0) {
			dataTypesToImport.add(Iterable)
			dataTypesToImport.add(ArrayList)
		}
		dataTypesToImport.addAll(getInnerTypes(dataTypes.filter(CollectionDataType)).filter(CompositeDataType))
		return dataTypesToImport
	}
	
	private def Iterable<DataType> getInnerTypes(Iterable<CollectionDataType> types) {
		val innerTypes = new ArrayList<DataType>
		for (type : types) {
			innerTypes.add(type.innerType)
		}
		return innerTypes
	}
	
	private def DataType getInnerType(CollectionDataType type) {
		val innerType = type.innerType_CollectionDataType
		switch (innerType) {
			CollectionDataType : return innerType.innerType
			CompositeDataType,
			PrimitiveDataType : return innerType
			default : return null
		}
	}
	
	private def dispatch Iterable<Object> getElementsToImport(OperationInterface iface) {
		return getTypesUsedInSignaturesOfProvidedServices(iface)
	}
	
	private def Iterable<Object> getTypesUsedInSignaturesOfProvidedServices(OperationInterface iface) {
		val usedTypes =  new HashSet<Object>
		for (providedSignature : iface.signatures__OperationInterface) {
			usedTypes.addAll(getDataTypesToImport(#{providedSignature.returnType__OperationSignature}))
			usedTypes.addAll(getDataTypesToImport(providedSignature.parameters__OperationSignature.map[it.dataType__Parameter]))
		}
		usedTypes.remove(ArrayList) //ArrayList not needed if collection data type is only used in signature
		return usedTypes
	}
	
	private def dispatch Iterable<Object> getElementsToImport(BasicComponent bc) {
		val elementsToImport = new HashSet<Object>()
		elementsToImport.addAll(getProvidedInterfaces(bc))
		elementsToImport.addAll(getRequiredInterfaces(bc))
		elementsToImport.addAll(bc.typesUsedInSignaturesOfProvidedServices)
		for (iface : bc.allInheritedOperationInterfaces) {
			elementsToImport.addAll(iface.typesUsedInSignaturesOfProvidedServices) // 
		}
		return elementsToImport
	}
	
	private def Iterable<Object> getTypesUsedInSignaturesOfProvidedServices(InterfaceProvidingEntity ipe) {
		val usedTypes = new HashSet<Object>()
		for (providedInterface : getProvidedInterfaces(ipe)) {
			usedTypes.addAll(getTypesUsedInSignaturesOfProvidedServices(providedInterface))
		}
		return usedTypes
	}

	private dispatch def String generateImport(EObject eObject) {
		val fullyQualifiedTypeToImport = getTargetName(eObject, true) + getSeparator(true) + getTargetFileName(eObject)
		return generateImport(fullyQualifiedTypeToImport)
	}
	
	private dispatch def String generateImport(String fullyQualifiedTypeToImport) '''import «fullyQualifiedTypeToImport»;
	'''
	
	private dispatch def String generateImport(Class<?> c) '''import «c.name»;
	'''

	/**
	 * Returns the type of the DataType that is contained in the given InnerDeclaration as String.
	 */
	private def String getInnerDeclarationClassName(InnerDeclaration declaration){
		return getClassNameOfDataType(declaration.datatype_InnerDeclaration)
	}
	
	/** 
	 * Returns the name of the reference class of the primitive type the given data type contains.
	 * */
	private dispatch def String getClassNameOfDataType(PrimitiveDataType dataType) {
		return getTargetFileName(dataType)
	}
	
	/**
	 * Returns "Iterable<name of class of inner type>".
	 * If the inner type is null "Iterable<Object>" is returned.
	 */
	private dispatch def String getClassNameOfDataType(CollectionDataType dataType) {
		val innerType = dataType.innerType_CollectionDataType
		switch innerType {
			case CollectionDataType: return "Iterable<" + (innerType as NamedElement).entityName + ">"
			case null: return "Iterable<Object>"
			default: return "Iterable<" + innerType.getClassNameOfDataType.primitiveToReferenceName + ">"
		}
	}
	
	/**
	 * Returns the entity name of the given composite data type.
	 */
	private dispatch def String getClassNameOfDataType(CompositeDataType dataType) {
		return dataType.entityName
	}

	//TODO Move to PCM Helper class?
	private def String primitiveToReferenceName(String type) {
		switch type {
			case "int": return "Integer"
			case "byte": return "Byte"
			case "short": return "Short"
			case "long": return "Long"
			case "float": return "Float"
			case "double": return "Double"
			case "char": return "Character"
			case "boolean": return "Boolean"
			default: return type
		}
	}
	
	/**
	 * Returns a list of all inner declarations of the given data type that are not primitive.
	 * That includes inner declarations with type String as it is a reference type.
	 */
	private def Iterable<InnerDeclaration> getNonPrimitiveDeclarations(CompositeDataType dataType) {
		val nonPrimitiveFields = new ArrayList<InnerDeclaration>
		for (declaration : dataType.innerDeclaration_CompositeDataType) {
			switch (declaration.datatype_InnerDeclaration) {
				CollectionDataType, 
				CompositeDataType: nonPrimitiveFields.add(declaration) 
				PrimitiveDataType: if (declaration.datatype_InnerDeclaration.classNameOfDataType.equals("String")) {
								   	   nonPrimitiveFields.add(declaration)
								   }
			}
		}
		return nonPrimitiveFields
	}
	
	private def Iterable<OperationInterface> getAllInheritedOperationInterfaces(OperationInterface iface) {
		val inheritedIfaces = new HashSet<OperationInterface>
		inheritedIfaces.addAll(iface.directInheritedOperationInterfaces)
		inheritedIfaces.addAll(iface.indirectInheritedOperationInterfaces)
		return inheritedIfaces
	}

	private def Iterable<OperationInterface> getDirectInheritedOperationInterfaces(OperationInterface iface) {
		return iface.parentInterfaces__Interface.toSet.filter(OperationInterface)
	}
	
	private def Iterable<OperationInterface> getIndirectInheritedOperationInterfaces(OperationInterface iface) {	
		return iface.parentInterfaces__Interface.map[it.parentInterfaces__Interface].filter(OperationInterface)
	}

	private def Iterable<OperationInterface> getAllInheritedOperationInterfaces(BasicComponent bc) {
		val inheritedIfaces = new HashSet<OperationInterface>
		inheritedIfaces.addAll(bc.directInheritedOperationInterfaces)
		inheritedIfaces.addAll(bc.indirectInheritedOperationInterfaces)
		return inheritedIfaces
	}
	
	private def Iterable<OperationInterface> getDirectInheritedOperationInterfaces(BasicComponent bc) {
		return getProvidedInterfaces(bc).map[it.parentInterfaces__Interface].flatten.filter(OperationInterface)
	}
	
	private def Iterable<OperationInterface> getIndirectInheritedOperationInterfaces(BasicComponent bc) {
		return getProvidedInterfaces(bc).map[it.parentInterfaces__Interface].flatten.filter(OperationInterface).map[it.allInheritedOperationInterfaces].flatten
	}

}
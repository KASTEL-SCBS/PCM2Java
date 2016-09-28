package edu.kit.ipd.sdq.mdsd.pcm2java.generator;

import com.google.common.collect.Iterables;
import edu.kit.ipd.sdq.commons.ecore2txt.generator.AbstractEcore2TxtGenerator;
import edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGeneratorConstants;
import edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaTargetNameUtil;
import edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCMUtil;
import edu.kit.ipd.sdq.mdsd.pcm2java.generator.UnsupportedGeneratorInput;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.internal.xtend.util.Triplet;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.ListExtensions;
import org.eclipse.xtext.xbase.lib.StringExtensions;
import org.palladiosimulator.pcm.core.entity.InterfaceProvidingEntity;
import org.palladiosimulator.pcm.core.entity.NamedElement;
import org.palladiosimulator.pcm.repository.BasicComponent;
import org.palladiosimulator.pcm.repository.CollectionDataType;
import org.palladiosimulator.pcm.repository.CompositeDataType;
import org.palladiosimulator.pcm.repository.DataType;
import org.palladiosimulator.pcm.repository.InnerDeclaration;
import org.palladiosimulator.pcm.repository.Interface;
import org.palladiosimulator.pcm.repository.OperationInterface;
import org.palladiosimulator.pcm.repository.OperationProvidedRole;
import org.palladiosimulator.pcm.repository.OperationSignature;
import org.palladiosimulator.pcm.repository.Parameter;
import org.palladiosimulator.pcm.repository.PrimitiveDataType;
import org.palladiosimulator.pcm.repository.PrimitiveTypeEnum;
import org.palladiosimulator.pcm.repository.ProvidedRole;
import tools.vitruv.framework.util.bridges.EcoreBridge;

@SuppressWarnings("all")
public class PCM2JavaGenerator extends AbstractEcore2TxtGenerator {
  @Override
  public String getFolderNameForResource(final Resource inputResource) {
    throw new UnsupportedOperationException();
  }
  
  @Override
  public String getFileNameForResource(final Resource inputResource) {
    throw new UnsupportedOperationException();
  }
  
  @Override
  public String postProcessGeneratedContents(final String contents) {
    return contents;
  }
  
  @Override
  public Iterable<Triplet<String, String, String>> generateContentsFromResource(final Resource inputResource) {
    final ArrayList<Triplet<String, String, String>> contentsForFolderAndFileNames = new ArrayList<Triplet<String, String, String>>();
    this.generateAndAddContents(inputResource, contentsForFolderAndFileNames);
    return contentsForFolderAndFileNames;
  }
  
  private void generateAndAddContents(final Resource inputResource, final List<Triplet<String, String, String>> contentsForFolderAndFileNames) {
    Iterable<EObject> _allContents = EcoreBridge.getAllContents(inputResource);
    for (final EObject element : _allContents) {
      {
        final String content = this.generateContent(element);
        boolean _equals = false;
        if (content!=null) {
          _equals=content.equals("");
        }
        boolean _not = (!_equals);
        if (_not) {
          final String folderName = PCM2JavaTargetNameUtil.getTargetName(element, false);
          String _targetFileName = PCM2JavaTargetNameUtil.getTargetFileName(element);
          String _targetFileExt = PCM2JavaGeneratorConstants.getTargetFileExt();
          final String fileName = (_targetFileName + _targetFileExt);
          final Triplet<String, String, String> contentAndFileName = new Triplet<String, String, String>(content, folderName, fileName);
          contentsForFolderAndFileNames.add(contentAndFileName);
        }
      }
    }
  }
  
  protected String _generateContent(final EObject object) {
    return "";
  }
  
  protected String _generateContent(final CompositeDataType dataType) {
    final String importsAndClassifierHead = this.generateImportsAndInterfaceHead(dataType);
    final CharSequence fields = this.generateFields(dataType);
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("{");
    _builder.newLine();
    _builder.newLine();
    _builder.append("\t");
    _builder.append(fields, "\t");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.newLine();
    _builder.append("\t");
    _builder.append("// FIXME MK generate constructors in composite data types");
    _builder.newLine();
    _builder.append("}");
    return (importsAndClassifierHead + _builder);
  }
  
  private CharSequence generateFields(final CompositeDataType dataType) {
    StringConcatenation _builder = new StringConcatenation();
    {
      EList<InnerDeclaration> _innerDeclaration_CompositeDataType = dataType.getInnerDeclaration_CompositeDataType();
      boolean _hasElements = false;
      for(final InnerDeclaration declaration : _innerDeclaration_CompositeDataType) {
        if (!_hasElements) {
          _hasElements = true;
        } else {
          _builder.appendImmediate("\n", "");
        }
        _builder.append("private ");
        String _innerDeclarationClassName = this.getInnerDeclarationClassName(declaration);
        _builder.append(_innerDeclarationClassName, "");
        _builder.append(" ");
        String _entityName = declaration.getEntityName();
        String _firstLower = StringExtensions.toFirstLower(_entityName);
        _builder.append(_firstLower, "");
        _builder.append(";");
      }
    }
    return _builder;
  }
  
  /**
   * Returns the name of the class declared in a InnerDeclaration as String.
   * If it's a primitive type the string is in lower case,
   * otherwise the name exact name of the class will be returned.
   * 
   * TODO: Move to PCM Helper class
   */
  private String getInnerDeclarationClassName(final InnerDeclaration declaration) {
    final DataType dataType = declaration.getDatatype_InnerDeclaration();
    if ((dataType instanceof PrimitiveDataType)) {
      PrimitiveTypeEnum _type = ((PrimitiveDataType) dataType).getType();
      String _string = _type.toString();
      return _string.toLowerCase();
    }
    if ((dataType instanceof CollectionDataType)) {
      return ((CollectionDataType) dataType).getEntityName();
    }
    if ((dataType instanceof CompositeDataType)) {
      return ((CompositeDataType) dataType).getEntityName();
    }
    return null;
  }
  
  protected String _generateContent(final OperationInterface iface) {
    final String importsAndClassifierHead = this.generateImportsAndInterfaceHead(iface);
    final CharSequence implementsRelations = this.generateImplementsRelations(iface);
    EList<OperationSignature> _signatures__OperationInterface = iface.getSignatures__OperationInterface();
    final CharSequence methodDeclarations = this.generateMethodDeclarations(_signatures__OperationInterface);
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("{");
    _builder.newLine();
    _builder.append("\t");
    _builder.append(methodDeclarations, "\t");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.append("// FIXME MK support all cases of method declarations for service signatures in interfaces");
    _builder.newLine();
    _builder.append("}");
    return ((importsAndClassifierHead + implementsRelations) + _builder);
  }
  
  public CharSequence generateMethodDeclarations(final Iterable<OperationSignature> operationSignatures) {
    StringConcatenation _builder = new StringConcatenation();
    {
      boolean _hasElements = false;
      for(final OperationSignature operationSignature : operationSignatures) {
        if (!_hasElements) {
          _hasElements = true;
        } else {
          _builder.appendImmediate(";\n", "");
        }
        String _generateMethodDeclarationWithoutSemicolon = this.generateMethodDeclarationWithoutSemicolon(operationSignature);
        _builder.append(_generateMethodDeclarationWithoutSemicolon, "");
      }
      if (_hasElements) {
        _builder.append(";\n", "");
      }
    }
    return _builder;
  }
  
  private CharSequence generateImplementsRelations(final OperationInterface iface) {
    StringConcatenation _builder = new StringConcatenation();
    {
      Iterable<OperationInterface> _inheritedOperationInterfaces = this.getInheritedOperationInterfaces(iface);
      boolean _hasElements = false;
      for(final OperationInterface providedInterface : _inheritedOperationInterfaces) {
        if (!_hasElements) {
          _hasElements = true;
          _builder.append("implements ", "");
        } else {
          _builder.appendImmediate(", ", "");
        }
        String _entityName = providedInterface.getEntityName();
        String _firstUpper = StringExtensions.toFirstUpper(_entityName);
        _builder.append(_firstUpper, "");
      }
      if (_hasElements) {
        _builder.append(" ", "");
      }
    }
    return _builder;
  }
  
  private String generateMethodDeclarationWithoutSemicolon(final OperationSignature operationSignature) {
    DataType _returnType__OperationSignature = operationSignature.getReturnType__OperationSignature();
    final String returnType = PCM2JavaTargetNameUtil.getTargetFileName(_returnType__OperationSignature);
    final String methodName = PCMUtil.getMethodName(operationSignature);
    StringConcatenation _builder = new StringConcatenation();
    {
      EList<Parameter> _parameters__OperationSignature = operationSignature.getParameters__OperationSignature();
      boolean _hasElements = false;
      for(final Parameter parameter : _parameters__OperationSignature) {
        if (!_hasElements) {
          _hasElements = true;
        } else {
          _builder.appendImmediate(", ", "");
        }
        DataType _dataType__Parameter = parameter.getDataType__Parameter();
        String _targetFileName = PCM2JavaTargetNameUtil.getTargetFileName(_dataType__Parameter);
        _builder.append(_targetFileName, "");
        _builder.append(" ");
        String _parameterName = PCMUtil.getParameterName(parameter);
        _builder.append(_parameterName, "");
      }
    }
    final String parameterDeclarations = _builder.toString();
    StringConcatenation _builder_1 = new StringConcatenation();
    _builder_1.append(returnType, "");
    _builder_1.append(" ");
    _builder_1.append(methodName, "");
    _builder_1.append("(");
    _builder_1.append(parameterDeclarations, "");
    _builder_1.append(")");
    return _builder_1.toString();
  }
  
  protected String _generateContent(final BasicComponent bc) {
    final String importsAndClassifierHead = this.generateImportsAndClassHead(bc);
    final CharSequence implementsRelations = this.generateImplementsRelations(bc);
    final CharSequence fields = this.generateFields(bc);
    final CharSequence constructor = this.generateConstructor(bc);
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("{");
    _builder.newLine();
    _builder.append("\t\t\t");
    _builder.newLine();
    _builder.append("\t");
    _builder.append(fields, "\t");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.newLine();
    _builder.append("\t");
    _builder.append(constructor, "\t");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.newLine();
    _builder.append("\t");
    String _generateMethodDefinitions = this.generateMethodDefinitions(bc);
    _builder.append(_generateMethodDefinitions, "\t");
    _builder.newLineIfNotEmpty();
    _builder.append("}");
    return ((importsAndClassifierHead + implementsRelations) + _builder);
  }
  
  private String generateMethodDefinitions(final BasicComponent bc) {
    EList<ProvidedRole> _providedRoles_InterfaceProvidingEntity = bc.getProvidedRoles_InterfaceProvidingEntity();
    Iterable<OperationProvidedRole> _filter = Iterables.<OperationProvidedRole>filter(_providedRoles_InterfaceProvidingEntity, OperationProvidedRole.class);
    final Function1<OperationProvidedRole, OperationInterface> _function = (OperationProvidedRole it) -> {
      return it.getProvidedInterface__OperationProvidedRole();
    };
    Iterable<OperationInterface> _map = IterableExtensions.<OperationProvidedRole, OperationInterface>map(_filter, _function);
    final Function1<OperationInterface, EList<OperationSignature>> _function_1 = (OperationInterface it) -> {
      return it.getSignatures__OperationInterface();
    };
    Iterable<EList<OperationSignature>> _map_1 = IterableExtensions.<OperationInterface, EList<OperationSignature>>map(_map, _function_1);
    Iterable<OperationSignature> _flatten = Iterables.<OperationSignature>concat(_map_1);
    CharSequence _generateMethodDefinitions = this.generateMethodDefinitions(_flatten);
    String methodDefinitions = _generateMethodDefinitions.toString();
    final Iterable<OperationInterface> inheritedInterfaces = this.getInheritedOperationInterfaces(bc);
    for (final OperationInterface iface : inheritedInterfaces) {
      String _methodDefinitions = methodDefinitions;
      EList<OperationSignature> _signatures__OperationInterface = iface.getSignatures__OperationInterface();
      CharSequence _generateMethodDefinitions_1 = this.generateMethodDefinitions(_signatures__OperationInterface);
      methodDefinitions = (_methodDefinitions + _generateMethodDefinitions_1);
    }
    return methodDefinitions;
  }
  
  private CharSequence generateMethodDefinitions(final Iterable<OperationSignature> operationSignatures) {
    StringConcatenation _builder = new StringConcatenation();
    {
      boolean _hasElements = false;
      for(final OperationSignature operationSignature : operationSignatures) {
        if (!_hasElements) {
          _hasElements = true;
        } else {
          _builder.appendImmediate("{\n\t// TODO: implement and verify auto-generated method stub\n\tthrow new UnsupportedOperationException(\"TODO: auto-generated method stub\")\n}\n\n", "");
        }
        String _generateMethodDeclarationWithoutSemicolon = this.generateMethodDeclarationWithoutSemicolon(operationSignature);
        _builder.append(_generateMethodDeclarationWithoutSemicolon, "");
      }
      if (_hasElements) {
        _builder.append("{\n\t// TODO: implement and verify auto-generated method stub\n\tthrow new UnsupportedOperationException(\"TODO: auto-generated method stub\")\n}\n\n", "");
      }
    }
    _builder.newLineIfNotEmpty();
    return _builder;
  }
  
  private CharSequence generateImplementsRelations(final BasicComponent bc) {
    StringConcatenation _builder = new StringConcatenation();
    {
      Iterable<OperationInterface> _providedInterfaces = PCMUtil.getProvidedInterfaces(bc);
      boolean _hasElements = false;
      for(final OperationInterface providedInterface : _providedInterfaces) {
        if (!_hasElements) {
          _hasElements = true;
          _builder.append("implements ", "");
        } else {
          _builder.appendImmediate(", ", "");
        }
        String _entityName = providedInterface.getEntityName();
        String _firstUpper = StringExtensions.toFirstUpper(_entityName);
        _builder.append(_firstUpper, "");
      }
      if (_hasElements) {
        _builder.append(" ", "");
      }
    }
    return _builder;
  }
  
  private CharSequence generateFields(final BasicComponent bc) {
    StringConcatenation _builder = new StringConcatenation();
    {
      Iterable<OperationInterface> _requiredInterfaces = PCMUtil.getRequiredInterfaces(bc);
      for(final OperationInterface iface : _requiredInterfaces) {
        _builder.append("private ");
        String _entityName = iface.getEntityName();
        String _firstUpper = StringExtensions.toFirstUpper(_entityName);
        _builder.append(_firstUpper, "");
        _builder.append(" ");
        String _entityName_1 = iface.getEntityName();
        String _firstLower = StringExtensions.toFirstLower(_entityName_1);
        _builder.append(_firstLower, "");
        _builder.append(";");
      }
    }
    return _builder;
  }
  
  private CharSequence generateConstructor(final BasicComponent bc) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("public ");
    String _entityName = bc.getEntityName();
    String _firstUpper = StringExtensions.toFirstUpper(_entityName);
    _builder.append(_firstUpper, "");
    _builder.append("() {");
    _builder.newLineIfNotEmpty();
    _builder.append("\t");
    _builder.append("// TODO: implement and verify auto-generated constructor. Add parameters to constructor calls if necessary.");
    _builder.newLine();
    {
      Iterable<OperationInterface> _requiredInterfaces = PCMUtil.getRequiredInterfaces(bc);
      for(final OperationInterface iface : _requiredInterfaces) {
        _builder.append("    this.");
        String _entityName_1 = iface.getEntityName();
        String _firstLower = StringExtensions.toFirstLower(_entityName_1);
        _builder.append(_firstLower, "");
        _builder.append(" = new ");
        String _entityName_2 = iface.getEntityName();
        String _firstUpper_1 = StringExtensions.toFirstUpper(_entityName_2);
        _builder.append(_firstUpper_1, "");
        _builder.append("();");
        _builder.newLineIfNotEmpty();
      }
    }
    _builder.append("}");
    return _builder;
  }
  
  private Iterable<? extends EObject> getTypesUsedInSignaturesOfProvidedServices(final InterfaceProvidingEntity ipe) {
    final HashSet<EObject> usedTypes = new HashSet<EObject>();
    Iterable<OperationInterface> _providedInterfaces = PCMUtil.getProvidedInterfaces(ipe);
    final Function1<OperationInterface, EList<OperationSignature>> _function = (OperationInterface it) -> {
      return it.getSignatures__OperationInterface();
    };
    Iterable<EList<OperationSignature>> _map = IterableExtensions.<OperationInterface, EList<OperationSignature>>map(_providedInterfaces, _function);
    Iterable<OperationSignature> _flatten = Iterables.<OperationSignature>concat(_map);
    for (final OperationSignature providedSignature : _flatten) {
      {
        DataType _returnType__OperationSignature = providedSignature.getReturnType__OperationSignature();
        Iterable<? extends EObject> _dataTypesToImport = this.getDataTypesToImport(Collections.<DataType>unmodifiableSet(CollectionLiterals.<DataType>newHashSet(_returnType__OperationSignature)));
        Iterables.<EObject>addAll(usedTypes, _dataTypesToImport);
        EList<Parameter> _parameters__OperationSignature = providedSignature.getParameters__OperationSignature();
        final Function1<Parameter, DataType> _function_1 = (Parameter it) -> {
          return it.getDataType__Parameter();
        };
        List<DataType> _map_1 = ListExtensions.<Parameter, DataType>map(_parameters__OperationSignature, _function_1);
        Iterable<? extends EObject> _dataTypesToImport_1 = this.getDataTypesToImport(_map_1);
        Iterables.<EObject>addAll(usedTypes, _dataTypesToImport_1);
      }
    }
    return usedTypes;
  }
  
  private String generateImportsAndInterfaceHead(final NamedElement namedElement) {
    return this.generateImportsAndClassifierHead(namedElement, "interface");
  }
  
  private String generateImportsAndClassHead(final NamedElement namedElement) {
    return this.generateImportsAndClassifierHead(namedElement, "class");
  }
  
  private String generateImportsAndClassifierHead(final NamedElement namedElement, final String classifierType) {
    final String packageDeclaration = this.generatePackageDeclaration(namedElement);
    final String imports = this.generateImports(namedElement);
    final String classifierName = namedElement.getEntityName();
    final String classifierHead = this.generateClassifierHeader(classifierType, classifierName);
    return ((packageDeclaration + imports) + classifierHead);
  }
  
  private String generatePackageDeclaration(final NamedElement element) {
    String _targetName = PCM2JavaTargetNameUtil.getTargetName(element, true);
    String _plus = ("package " + _targetName);
    StringConcatenation _builder = new StringConcatenation();
    _builder.append(";");
    _builder.newLine();
    _builder.newLine();
    return (_plus + _builder);
  }
  
  private String generateImports(final NamedElement namedElement) {
    String imports = "";
    Iterable<? extends EObject> elementsToImport = this.getElementsToImport(namedElement);
    for (final EObject elementToImport : elementsToImport) {
      String _imports = imports;
      String _generateImport = this.generateImport(elementToImport);
      imports = (_imports + _generateImport);
    }
    CharSequence _xifexpression = null;
    boolean _equals = imports.equals("");
    if (_equals) {
      _xifexpression = "";
    } else {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("\t\t");
      _builder.newLine();
      _xifexpression = _builder;
    }
    return (imports + _xifexpression);
  }
  
  private Iterable<? extends EObject> _getElementsToImport(final NamedElement namedElement) {
    throw new UnsupportedGeneratorInput("generate imports for", namedElement);
  }
  
  private Iterable<? extends EObject> _getElementsToImport(final CompositeDataType dataType) {
    EList<InnerDeclaration> _innerDeclaration_CompositeDataType = dataType.getInnerDeclaration_CompositeDataType();
    final Function1<InnerDeclaration, DataType> _function = (InnerDeclaration it) -> {
      return it.getDatatype_InnerDeclaration();
    };
    List<DataType> _map = ListExtensions.<InnerDeclaration, DataType>map(_innerDeclaration_CompositeDataType, _function);
    return this.getDataTypesToImport(_map);
  }
  
  private Iterable<? extends EObject> getDataTypesToImport(final Iterable<DataType> dataTypes) {
    return Iterables.<CompositeDataType>filter(dataTypes, CompositeDataType.class);
  }
  
  private Iterable<? extends EObject> _getElementsToImport(final OperationInterface iface) {
    return Collections.<EObject>emptyList();
  }
  
  private Iterable<? extends EObject> _getElementsToImport(final BasicComponent bc) {
    final ArrayList<EObject> elementsToImport = new ArrayList<EObject>();
    Iterable<OperationInterface> _providedInterfaces = PCMUtil.getProvidedInterfaces(bc);
    Iterables.<EObject>addAll(elementsToImport, _providedInterfaces);
    Iterable<OperationInterface> _requiredInterfaces = PCMUtil.getRequiredInterfaces(bc);
    Iterables.<EObject>addAll(elementsToImport, _requiredInterfaces);
    Iterable<? extends EObject> _typesUsedInSignaturesOfProvidedServices = this.getTypesUsedInSignaturesOfProvidedServices(bc);
    Iterables.<EObject>addAll(elementsToImport, _typesUsedInSignaturesOfProvidedServices);
    return elementsToImport;
  }
  
  private String generateImport(final EObject eObject) {
    String _targetName = PCM2JavaTargetNameUtil.getTargetName(eObject, true);
    String _separator = PCM2JavaGeneratorConstants.getSeparator(true);
    String _plus = (_targetName + _separator);
    String _targetFileName = PCM2JavaTargetNameUtil.getTargetFileName(eObject);
    final String fullyQualifiedTypeToImport = (_plus + _targetFileName);
    return this.generateImport(fullyQualifiedTypeToImport);
  }
  
  private String generateImport(final String fullyQualifiedTypeToImport) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("import ");
    _builder.append(fullyQualifiedTypeToImport, "");
    _builder.append(";");
    _builder.newLineIfNotEmpty();
    return _builder.toString();
  }
  
  private String generateClassifierHeader(final String classifierType, final String classifierName) {
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("public ");
    _builder.append(classifierType, "");
    _builder.append(" ");
    String _firstUpper = StringExtensions.toFirstUpper(classifierName);
    _builder.append(_firstUpper, "");
    _builder.append(" ");
    return _builder.toString();
  }
  
  private Iterable<OperationInterface> getInheritedOperationInterfaces(final OperationInterface iface) {
    final ArrayList<OperationInterface> inheritedOperationInterfaces = new ArrayList<OperationInterface>();
    final ArrayList<Interface> toIterate = new ArrayList<Interface>();
    EList<Interface> _parentInterfaces__Interface = iface.getParentInterfaces__Interface();
    toIterate.addAll(_parentInterfaces__Interface);
    while ((!toIterate.isEmpty())) {
      {
        final Interface iterator = toIterate.get(0);
        EList<Interface> _parentInterfaces__Interface_1 = iterator.getParentInterfaces__Interface();
        toIterate.addAll(_parentInterfaces__Interface_1);
        if ((iterator instanceof OperationInterface)) {
          inheritedOperationInterfaces.add(((OperationInterface)iterator));
        }
        toIterate.remove(0);
      }
    }
    return inheritedOperationInterfaces;
  }
  
  private Iterable<OperationInterface> getInheritedOperationInterfaces(final BasicComponent bc) {
    final ArrayList<OperationInterface> inheritedOperationInterfaces = new ArrayList<OperationInterface>();
    Iterable<OperationInterface> _providedInterfaces = PCMUtil.getProvidedInterfaces(bc);
    for (final OperationInterface iface : _providedInterfaces) {
      Iterable<OperationInterface> _inheritedOperationInterfaces = this.getInheritedOperationInterfaces(iface);
      Iterables.<OperationInterface>addAll(inheritedOperationInterfaces, _inheritedOperationInterfaces);
    }
    return inheritedOperationInterfaces;
  }
  
  public String generateContent(final EObject bc) {
    if (bc instanceof BasicComponent) {
      return _generateContent((BasicComponent)bc);
    } else if (bc instanceof OperationInterface) {
      return _generateContent((OperationInterface)bc);
    } else if (bc instanceof CompositeDataType) {
      return _generateContent((CompositeDataType)bc);
    } else if (bc != null) {
      return _generateContent(bc);
    } else {
      throw new IllegalArgumentException("Unhandled parameter types: " +
        Arrays.<Object>asList(bc).toString());
    }
  }
  
  private Iterable<? extends EObject> getElementsToImport(final NamedElement bc) {
    if (bc instanceof BasicComponent) {
      return _getElementsToImport((BasicComponent)bc);
    } else if (bc instanceof OperationInterface) {
      return _getElementsToImport((OperationInterface)bc);
    } else if (bc instanceof CompositeDataType) {
      return _getElementsToImport((CompositeDataType)bc);
    } else if (bc != null) {
      return _getElementsToImport(bc);
    } else {
      throw new IllegalArgumentException("Unhandled parameter types: " +
        Arrays.<Object>asList(bc).toString());
    }
  }
}

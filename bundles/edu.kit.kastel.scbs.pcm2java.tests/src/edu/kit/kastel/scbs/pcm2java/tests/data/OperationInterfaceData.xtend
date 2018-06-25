package edu.kit.kastel.scbs.pcm2java.tests.data

import java.util.ArrayList
import java.util.Collection
import org.palladiosimulator.pcm.repository.OperationInterface
import org.palladiosimulator.pcm.repository.OperationSignature

class OperationInterfaceData {
    
    private String name
    private Collection<OperationInterface> parentInterfaces
    private Collection<OperationSignature> operationSignatures
    
    new(String name) {
        setName(name)
        setParentInterfaces(null)
        setOperationSignatures(null)
    }
    
    new(String name, Collection<OperationSignature> operationSignatures) {
        setName(name)
        setParentInterfaces(null)
        setOperationSignatures(operationSignatures)
    }
    
    new(String name, Collection<OperationSignature> operationSignatures, OperationInterface parentInterface) {
        setName(name)
        val pInterfaces = new ArrayList<OperationInterface>
        pInterfaces.add(parentInterface)
        setParentInterfaces(pInterfaces)
        setOperationSignatures(operationSignatures)
    }
    
    new(String name, Collection<OperationSignature> operationSignatures, Collection<OperationInterface> parentInterfaces) {
        setName(name)
        setParentInterfaces(parentInterfaces)
        setOperationSignatures(operationSignatures)
    }
    
     def String getName() {
        name
     }
     
     def Collection<OperationInterface> getParentInterfaces() {
        parentInterfaces
     }
     
     def Collection<OperationSignature> getOperationSignatures() {
        operationSignatures
     }
    
    private def void setName(String name) {
        if (name !== null) {
            this.name = name
        } else {
            this.name = ""
        }
    }
    
    private def void setParentInterfaces(Collection<OperationInterface> parentInterfaces) {
        this.parentInterfaces = new ArrayList<OperationInterface>
        if (parentInterfaces !== null) {
            this.parentInterfaces.addAll(parentInterfaces)
        }
    }
    
    private def void setOperationSignatures(Collection<OperationSignature> operationSignatures) {
        this.operationSignatures = new ArrayList<OperationSignature>
        if (operationSignatures !== null) {
            this.operationSignatures.addAll(operationSignatures)
        }
    }
    
}
package edu.kit.kastel.scbs.pcm2java.tests

import edu.kit.kastel.scbs.pcm2java.tests.data.OperationInterfaceData
import java.util.ArrayList
import java.util.Collection
import org.palladiosimulator.pcm.repository.OperationInterface
import org.palladiosimulator.pcm.repository.OperationSignature
import org.palladiosimulator.pcm.repository.RepositoryFactory

class TestOperationInterfaceBuilder {
    
    static def Iterable<OperationInterface> buildOperationInterfaces(Iterable<OperationInterfaceData> data) {
        val operationInterfaces = new ArrayList<OperationInterface>
        for (datum : data) {
            operationInterfaces.add(buildOperationInterface(datum))
        }
        return operationInterfaces
    }
    
    static def OperationInterface buildOperationInterface(OperationInterfaceData ifaceData) {
        buildOperationInterface(ifaceData.name, ifaceData.parentInterfaces, ifaceData.operationSignatures)
    }
    
    private static def OperationInterface buildOperationInterface(String name, Collection<OperationInterface> parentInterfaces, Collection<OperationSignature> operationSignatures) {
        val iface =  RepositoryFactory.eINSTANCE.createOperationInterface
        iface.entityName = name
        iface.parentInterfaces__Interface.addAll(parentInterfaces)
        iface.signatures__OperationInterface.addAll(operationSignatures)
        return iface
    }
}
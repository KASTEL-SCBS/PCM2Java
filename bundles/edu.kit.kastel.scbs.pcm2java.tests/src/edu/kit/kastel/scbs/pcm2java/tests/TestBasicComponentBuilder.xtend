package edu.kit.kastel.scbs.pcm2java.tests;

import org.palladiosimulator.pcm.repository.BasicComponent
import edu.kit.kastel.scbs.pcm2java.tests.data.BasicComponentData
import java.util.ArrayList
import org.palladiosimulator.pcm.repository.OperationInterface
import java.util.Collection
import org.palladiosimulator.pcm.repository.RepositoryFactory
import org.palladiosimulator.pcm.repository.RequiredRole
import org.palladiosimulator.pcm.repository.ProvidedRole

class TestBasicComponentBuilder {
    
    static def Iterable<BasicComponent> buildBasicComponents(Iterable<BasicComponentData> data) {
        val basicComponents = new ArrayList<BasicComponent>
        for (datum : data) {
            basicComponents.add(buildBasicComponent(datum))
        }
        return basicComponents
    }
    
    static def BasicComponent buildBasicComponent(BasicComponentData basicComponentData) {
        buildBasicComponent(basicComponentData.name, basicComponentData.requiredRoles, basicComponentData.providedRoles)
    }
    
    private static def BasicComponent buildBasicComponent(String name, Collection<OperationInterface> requiredInterfaces, Collection<OperationInterface> providedInterfaces) {
        val bc =  RepositoryFactory.eINSTANCE.createBasicComponent
        bc.entityName = name
        val requiredRoles = new ArrayList<RequiredRole>
        for (iface : requiredInterfaces) {
            val requiredRole = RepositoryFactory.eINSTANCE.createOperationRequiredRole
            requiredRole.requiredInterface__OperationRequiredRole  = iface
            requiredRoles.add(requiredRole)
            
        }
        val providedRoles = new ArrayList<ProvidedRole>
        for (iface : providedInterfaces) {
            val providedRole = RepositoryFactory.eINSTANCE.createOperationProvidedRole
            providedRole.providedInterface__OperationProvidedRole  = iface
            providedRoles.add(providedRole)
            
        }
        bc.requiredRoles_InterfaceRequiringEntity.addAll(requiredRoles)
        bc.providedRoles_InterfaceProvidingEntity.addAll(providedRoles)
        return bc
    }
    
}
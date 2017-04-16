package edu.kit.ipd.sdq.mdsd.pcm2java.generator

import org.palladiosimulator.pcm.repository.OperationSignature
import org.palladiosimulator.pcm.repository.Parameter
import org.palladiosimulator.pcm.repository.OperationInterface
import org.palladiosimulator.pcm.core.entity.InterfaceProvidingEntity
import org.palladiosimulator.pcm.repository.OperationProvidedRole
import org.palladiosimulator.pcm.core.entity.InterfaceRequiringEntity
import org.palladiosimulator.pcm.repository.OperationRequiredRole

// FIXME MK move to a new sdq commons PCMUtil
/**
 * A utility class for PCM elements
 * 
 */
class PCMUtil {
	
	/** Utility classes should not have a public or default constructor. */
	private new() {
	}
	
	static def String getMethodName(OperationSignature operationSignature) {
		return operationSignature.entityName.toFirstLower
	}
	
	static def String getParameterName(Parameter parameter) {
		parameter.parameterName.toFirstLower
	}
	
	static def Iterable<OperationInterface> getProvidedInterfaces(InterfaceProvidingEntity ipe) {
		return ipe.providedRoles_InterfaceProvidingEntity.filter(OperationProvidedRole).map[it.providedInterface__OperationProvidedRole]
	}

	static def Iterable<OperationInterface> getRequiredInterfaces(InterfaceRequiringEntity ire) {
		return ire.requiredRoles_InterfaceRequiringEntity.filter(OperationRequiredRole).map[it.requiredInterface__OperationRequiredRole]
	}
	
}
package edu.kit.ipd.sdq.mdsd.pcm2java.generator

import org.palladiosimulator.pcm.repository.OperationSignature
import org.palladiosimulator.pcm.seff.ResourceDemandingSEFF
import org.palladiosimulator.pcm.repository.BasicComponent
import org.palladiosimulator.pcm.seff.StartAction
import org.palladiosimulator.pcm.seff.StopAction
import org.palladiosimulator.pcm.seff.AbstractAction
import org.palladiosimulator.pcm.seff.ExternalCallAction
import edu.kit.ipd.sdq.mdsd.pcm2java.util.DataTypeUtil


class PCM2JavaGeneratorMethodBody {
	
	private OperationSignature currentProccessingSignature;
	
	protected def generateMethodBody(BasicComponent bc, OperationSignature operationSignature) {
		
		this.currentProccessingSignature = operationSignature;
		for (seff : bc.serviceEffectSpecifications__BasicComponent) {
			if (seff.describedService__SEFF.id.equals(operationSignature.id)) {
				if (seff instanceof ResourceDemandingSEFF) {
					return processSEFF(seff);
				}
			}
		}

		return '''{
			// TODO: implement and verify auto-generated method stub
			throw new UnsupportedOperationException("TODO: auto-generated method stub");
	}'''

	}

	private def processSEFF(ResourceDemandingSEFF seff) {
		for (action : seff.steps_Behaviour) {
			if (action instanceof StartAction) {
				return '''//TODO: refine and verify auto-generated content
				
«processAction(action.successor_AbstractAction)»''';
			}
		}
	}


	private def String processAction(AbstractAction action) {
		
		var thisAction = "";
		var successor = "";
		
		switch action {
			StopAction: return processAction(action)
			ExternalCallAction: thisAction = processAction(action)
			default: return ""
		}
		
		successor = processAction(action.successor_AbstractAction);
		
		return '''«thisAction»
«successor»'''
	}

	private def processAction(ExternalCallAction action) {
		var calledExternalService = action.calledService_ExternalService;
		var returnType = calledExternalService.returnType__OperationSignature;
		var variableAssignment = "";
		if(returnType !== null){
			var dataTypeNameOfReturn = DataTypeUtil.getClassNameOfDataType(returnType);
			var variableName = "callResultOf" + calledExternalService.entityName;
			variableAssignment = '''«dataTypeNameOfReturn» «variableName» = '''
		} 
		
		
		return '''
		//TODO: Auto-Generated Method Call, correct arguments have to be provided
		«variableAssignment»«calledExternalService.interface__OperationSignature.entityName.toFirstLower».«calledExternalService.entityName»(«generateDummyArguments(calledExternalService)»);'''
	}
	
	private def generateDummyArguments(OperationSignature signature){
		return '''«FOR parameter : signature.parameters__OperationSignature  SEPARATOR ', '»null«ENDFOR»'''
	}
	
	private def processAction(StopAction action){
		
		var returnClause = "";
		
		if(currentProccessingSignature.returnType__OperationSignature !== null){
			returnClause = '''//TODO: replace auto-generated return expression
return «DataTypeUtil.getStandardValue(currentProccessingSignature.returnType__OperationSignature)»'''
		}
		
		return returnClause;
		
	}
	
	
}
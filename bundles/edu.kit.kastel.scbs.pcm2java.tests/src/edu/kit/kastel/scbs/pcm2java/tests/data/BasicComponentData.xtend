package edu.kit.kastel.scbs.pcm2java.tests.data

import java.util.ArrayList
import java.util.Collection
import org.palladiosimulator.pcm.repository.OperationInterface

class BasicComponentData {
    
    private String name
    private Collection<OperationInterface> requiredRoles
    private Collection<OperationInterface> providedRoles
    
    new(String name) {
        setName(name)
        setRequiredRoles(null)
        setProvidedRoles(null)
    }
    
    new(String name, Collection<OperationInterface> requiredRoles) {
        setName(name)
        setRequiredRoles(requiredRoles)
        setProvidedRoles(null)
    }
    
    new(Collection<OperationInterface> providedRoles, String name) {
        setName(name)
        setProvidedRoles(providedRoles)
        setRequiredRoles(null)
    }
    
    new(String name, Collection<OperationInterface> requiredRoles, Collection<OperationInterface> providedRoles) {
        setName(name)
        setRequiredRoles(requiredRoles)
        setProvidedRoles(providedRoles)
    }
    
    def String getName() {
        name
    }
    
    def Collection<OperationInterface> getRequiredRoles() {
        requiredRoles
    }
    
    def Collection<OperationInterface> getProvidedRoles() {
        providedRoles
    }
    
    def void setName(String name) {
        if (name !== null) {
            this.name = name
        } else {
            this.name = ""
        }
    }
    
    def void setRequiredRoles(Collection<OperationInterface> requiredRoles) {
        this.requiredRoles = new ArrayList<OperationInterface>
        if (requiredRoles !== null) {
            this.requiredRoles.addAll(requiredRoles)
        }
    }
    
    def void setProvidedRoles(Collection<OperationInterface> providedRoles) {
        this.providedRoles = new ArrayList<OperationInterface>
        if (providedRoles !== null) {
            this.providedRoles.addAll(providedRoles)
        }
    }
 }
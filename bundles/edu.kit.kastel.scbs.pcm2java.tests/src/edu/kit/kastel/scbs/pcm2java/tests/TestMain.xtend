package edu.kit.kastel.scbs.pcm2java.tests

import edu.kit.ipd.sdq.mdsd.pcm2java.generator.PCM2JavaGenerator
import org.eclipse.emf.ecore.resource.impl.ResourceImpl
import org.palladiosimulator.pcm.core.entity.NamedElement

import static extension edu.kit.ipd.sdq.commons.util.org.eclipse.emf.ecore.resource.ResourceUtil.*

/**
 * This class is the main class of the work-in-progress test for the pcm2java code generation.
 * 
 * The Test is supposed to work as follows: A duplicate of the repository of the minimal2JavaExample is generated, for which code is then generated using the pcm2java generator.
 * Afterwards the generated code is compared to a previously verified gold standard. (See /res/ folder)
 * 
 * Right now only the repository duplicate is generated, the comparison is not yet implemented (See TestComparator).
 * The Comparison needs to be done using abstract syntax trees (See: https://www.eclipse.org/articles/Article-JavaCodeManipulation_AST/), as the actual code may vary when it comes
 * to the order of imports etc.
 * In order to do that, the generated code and the gold standard need to be translated into abstract syntax trees and these trees must then be compared.
 * 
 * After that, the test could be automated and turned into a JUnit test.
 */
class TestMain {
    def static void main(String[] args) {
        val generator = new PCM2JavaGenerator
        val builder = new TestRepositoryBuilder
        val repository = builder.minimal2JavaExampleRepository
        val resource = new ResourceImpl
        resource.contents.add(repository)
        val results = generator.generateContentsFromResource(resource)
        val unequal = TestComparator.compareMin2JavaGoldStandard(results)
        if (unequal.length == 0) println("\n TEST PASSED")
        else {
            println("\n TEST FAILED! UNEQUAL FILES: \n")
            for (name : unequal) {
                println(name)
            }
        }
    }
}
////////////////////////////////////////////////////////////////////////////////
// Copyright 2010 Michael Schmalle - Teoti Graphix, LLC
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software 
// distributed under the License is distributed on an "AS IS" BASIS, 
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and 
// limitations under the License
// 
// Author: Michael Schmalle, Principal Architect
// mschmalle at teotigraphix dot com
////////////////////////////////////////////////////////////////////////////////

package org.teotigraphix.as3builder.impl
{

/*

buildContainerStart( compilation-unit ) //
buildContainerStart( package )          // "package"
buildNode( name )                       // [\s] "my.domain.core" [\s]
buildContainerStart( content )          // "{" [\n]
buildContainerStart( class )            // "class"
buildNode( name )                       // [\s] "A" [\s]
buildNode( content )                    // "{" [\n]
buildContainerEnd( class )              // ""
buildContainerEnd( content )            // "} " [\n]
buildContainerEnd( package )            // ""
buildNode( content )                    // "}" [\n]
buildContainerEnd( compilation-unit )   // ""

*/

import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.ASDocNodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.api.KeyWords;
import org.teotigraphix.as3parser.api.Operators;
import org.teotigraphix.as3parser.core.Token;
import org.teotigraphix.as3parser.utils.ASTUtil;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class BuilderFactory
{
	public static var breakPackageBracket:Boolean = false;
	
	public static var breakTypeBracket:Boolean = false;
	
	public static var breakBlockBracket:Boolean = false;
	
	public static var newlinesBeforeMembers:int = 0;
	
	public static var newlinesAfterMembers:int = 0;
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private var indent:int = 0;
	
	/**
	 * @private
	 */
	private var lastToken:Token;
	
	//--------------------------------------------------------------------------
	//
	//  Protected :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  state
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _state:String;
	
	/**
	 * The current node state in the builder.
	 */
	protected function get state():String
	{
		return _state;
	}
	
	/**
	 * @private
	 */	
	protected function set state(value:String):void
	{
		if (value == AS3NodeKind.COMPILATION_UNIT 
			|| value == AS3NodeKind.PACKAGE
			||value == AS3NodeKind.CLASS
			||value == AS3NodeKind.INTERFACE
			||value == AS3NodeKind.FUNCTION)
		{
			_state = value;
		}
	}
	
	//----------------------------------
	//  contentState
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _contentState:String;
	
	/**
	 * The current node state in the builder.
	 */
	protected function get contentState():String
	{
		return _contentState;
	}
	
	/**
	 * @private
	 */	
	protected function set contentState(value:String):void
	{
		if (value == AS3NodeKind.COMPILATION_UNIT 
			|| value == AS3NodeKind.PACKAGE
			|| value == AS3NodeKind.CLASS
			|| value == AS3NodeKind.INTERFACE
			|| value == AS3NodeKind.FUNCTION)
		{
			_contentState = value;
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function BuilderFactory()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	public function buildTest(ast:IParserNode):String
	{
		// now I need to figure out how to efficently and dynamicly 
		// loop through all children and build their nodes accordingly
		if (!ast.isKind(AS3NodeKind.COMPILATION_UNIT))
		{
			throw new Error("root must be compilation-unit");
		}
		
		var sb:String = "";
		
		state = AS3NodeKind.COMPILATION_UNIT;
		contentState = AS3NodeKind.PACKAGE;
		
		var tokens:Vector.<Token> = build(ast);
		
		for each (var token:Token in tokens)
		{
			sb += token.text;
		}
		
		return sb;
	}
	
	/**
	 * Builds a String representation of the AST found in the source file.
	 * 
	 * @param file An ISourceFile containing complete AST to build.
	 * @return A String containg the built source code.
	 */
	public function buildFile(file:ISourceFile):String
	{
		return buildTest(file.compilationNode.node);
	}
	
	/**
	 * Builds a Token Vector representation of the AST found in the source file.
	 * 
	 * @param file An ISourceFile containing complete AST to build.
	 * @return A Vector full of Tokenized AST mirroring the source code.
	 */
	public function buildTokens(file:ISourceFile):Vector.<Token>
	{
		var ast:IParserNode = file.compilationNode.node;
		
		if (!ast.isKind(AS3NodeKind.COMPILATION_UNIT))
		{
			throw new Error("root must be compilation-unit");
		}
		
		contentState = AS3NodeKind.PACKAGE;
		state = AS3NodeKind.COMPILATION_UNIT;
		
		var tokens:Vector.<Token> = build(ast);
		
		return tokens;
	}
	
	/**
	 * @private
	 */	
	protected function build(ast:IParserNode, tokens:Vector.<Token> = null):Vector.<Token>
	{
		state = ast.kind;
		
		if (tokens == null)
			tokens = new Vector.<Token>();
		
		if (state != AS3NodeKind.COMPILATION_UNIT)
		{
			addToken(tokens, buildContainerBeforeStartNewline(ast));
			addToken(tokens, buildContainerStart(ast));
			addToken(tokens, buildContainerAfterStartNewline(ast));
			
			if (ast.hasKind(AS3NodeKind.CLASS))
				contentState = AS3NodeKind.CLASS;
			else if (ast.hasKind(AS3NodeKind.INTERFACE))
				contentState = AS3NodeKind.INTERFACE;
			else if (ast.hasKind(AS3NodeKind.FUNCTION))
				contentState = AS3NodeKind.FUNCTION;
		}
		
		var len:int = ast.numChildren;
		if (len > 0)
		{
			for (var i:int = 0; i < len; i++)
			{
				var node:IParserNode = ast.children[i] as IParserNode;
				
				if (node.isKind(AS3NodeKind.PACKAGE))
				{
					buildPackage(node, tokens);
				}
				else if (node.isKind(AS3NodeKind.IMPORT))
				{
					buildImport(node, tokens);
				}
				else if (node.isKind(AS3NodeKind.CLASS))
				{
					buildClassType(node, tokens);
				}
				else if (node.isKind(AS3NodeKind.INTERFACE))
				{
					buildInterfaceType(node, tokens);
				}
				else if (node.isKind(AS3NodeKind.FUNCTION) && state == AS3NodeKind.PACKAGE)
				{
					buildFunctionType(node, tokens);
				}
				else if (node.isKind(AS3NodeKind.CONST_LIST))
				{
					addNewlinesBeforeMembers(node, tokens);
					buildConstant(node, tokens);
					addNewlinesAfterMembers(node, tokens);
					if (i < len - 1)
						addToken(tokens, newNewLine());
				}
				else if (node.isKind(AS3NodeKind.VAR_LIST))
				{
					addNewlinesBeforeMembers(node, tokens);
					buildAttribute(node, tokens);
					addNewlinesAfterMembers(node, tokens);
					if (i < len - 1)
						addToken(tokens, newNewLine());
				}
				else if (node.isKind(AS3NodeKind.GET))
				{
					addNewlinesBeforeMembers(node, tokens);
					buildGetter(node, tokens);
					addNewlinesAfterMembers(node, tokens);
					if (i < len - 1)
						addToken(tokens, newNewLine());
				}
				else if (node.isKind(AS3NodeKind.SET))
				{
					addNewlinesBeforeMembers(node, tokens);
					buildSetter(node, tokens);
					addNewlinesAfterMembers(node, tokens);
					if (i < len - 1)
						addToken(tokens, newNewLine());
				}
				else if (node.isKind(AS3NodeKind.FUNCTION))
				{
					addNewlinesBeforeMembers(node, tokens);
					buildFunction(node, tokens);
					addNewlinesAfterMembers(node, tokens);
					if (i < len - 1)
						addToken(tokens, newNewLine());
				}
				else if (node.isKind(AS3NodeKind.BLOCK))
				{
					//addNewlinesBeforeMembers(node, tokens);
					buildBlock(node, tokens);
					//addNewlinesAfterMembers(node, tokens);
					//if (i < len - 1)
					//	addToken(tokens, newNewLine());
				}
				else
				{
					tokens = build(node, tokens);
				}
			}
		}
		
		if (ast.isKind(AS3NodeKind.BLOCK))
		{
			if (ast.numChildren > 0)
				addToken(tokens, newNewLine());
			//addNewlinesBeforeMembers(node, tokens);
			buildBlock(ast, tokens);
			//addNewlinesAfterMembers(node, tokens);
			//if (i < len - 1)
			//addToken(tokens, newNewLine());
		}
		
		if (state != AS3NodeKind.COMPILATION_UNIT)
		{
			addToken(tokens, buildContainerEndNewline(ast));
			addToken(tokens, buildContainerEnd(ast));
		}
		
		if (ast.numChildren == 0 && state != AS3NodeKind.PACKAGE)
		{
			addToken(tokens, buildStartSpace(ast));
			addToken(tokens, buildNode(ast));
			addToken(tokens, buildEndSpace(ast));
		}
		
		return tokens;
	}
	
	/**
	 * node is (package)
	 */
	private function buildPackage(node:IParserNode, tokens:Vector.<Token>):void
	{
		// block-doc
		buildBlockDoc(node, tokens);
		// package
		addToken(tokens, newPackage());
		addToken(tokens, newSpace());
		// name
		var name:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, node);
		if (name.stringValue && name.stringValue != null)
		{
			addToken(tokens, newToken(name.stringValue));
			addToken(tokens, newSpace());
		}
		
		// content
		build(node, tokens);
	}
	
	/**
	 * node is (class)
	 */
	private function buildClassType(node:IParserNode, tokens:Vector.<Token>):void
	{
		state = AS3NodeKind.CLASS;
		// meta-list
		buildMetaList(node, tokens);
		// as-doc
		buildAsDoc(node, tokens);
		// modifiers
		buildModList(node, tokens);
		// class
		addToken(tokens, newClass());
		addToken(tokens, newSpace());
		// name
		var name:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, node);
		addToken(tokens, newToken(name.stringValue));
		addToken(tokens, newSpace());
		// extends
		var extendz:IParserNode = ASTUtil.getNode(AS3NodeKind.EXTENDS, node);
		if (extendz)
		{
			addToken(tokens, newToken(KeyWords.EXTENDS));
			addToken(tokens, newSpace());
			addToken(tokens, newToken(extendz.stringValue));
			addToken(tokens, newSpace());
		}
		// implements
		var impls:IParserNode = ASTUtil.getNode(AS3NodeKind.IMPLEMENTS_LIST, node);
		if (impls)
		{
			addToken(tokens, newToken(KeyWords.IMPLEMENTS));
			addToken(tokens, newSpace());
			var len:int = impls.numChildren;
			for (var i:int = 0; i < len; i++)
			{
				var impl:IParserNode = impls.children[i] as IParserNode;
				addToken(tokens, newToken(impl.stringValue));
				if (i < len - 1)
					addToken(tokens, newComma());
				addToken(tokens, newSpace());
			}
		}
		// content
		var content:IParserNode = ASTUtil.getNode(AS3NodeKind.CONTENT, node);
		build(content, tokens);
	}
	
	/**
	 * node is (interface)
	 */
	private function buildInterfaceType(node:IParserNode, tokens:Vector.<Token>):void
	{
		state = AS3NodeKind.INTERFACE;
		// modifiers
		buildModList(node, tokens);
		// interface
		addToken(tokens, newInterface());
		addToken(tokens, newSpace());
		// name
		var name:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, node);
		addToken(tokens, newToken(name.stringValue));
		addToken(tokens, newSpace());
		// extends
		var extendz:Vector.<IParserNode> = ASTUtil.getNodes(AS3NodeKind.EXTENDS, node);
		if (extendz && extendz.length > 0)
		{
			addToken(tokens, newToken(KeyWords.EXTENDS));
			addToken(tokens, newSpace());
			var len:int = extendz.length;
			for (var i:int = 0; i < len; i++)
			{
				var extend:IParserNode = extendz[i] as IParserNode;
				addToken(tokens, newToken(extend.stringValue));
				if (i < len - 1)
					tokens.push(newComma());
				addToken(tokens, newSpace());
			}
		}
		// content
		var content:IParserNode = ASTUtil.getNode(AS3NodeKind.CONTENT, node);
		build(content, tokens);
	}
	
	/**
	 * node is (function) in package
	 */
	private function buildFunctionType(node:IParserNode, tokens:Vector.<Token>):void
	{
		// as-doc
		buildAsDoc(node, tokens);
		// mod-list
		buildModList(node, tokens);
		// function
		addToken(tokens, newToken(KeyWords.FUNCTION));
		addToken(tokens, newSpace());
		// name
		var name:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, node);
		addToken(tokens, newToken(name.stringValue));
		// param-list
		buildParamList(node, tokens);
		// returnType
		var returnType:IParserNode = ASTUtil.getNode(AS3NodeKind.TYPE, node);
		if (returnType)
		{
			addToken(tokens, newColumn());
			addToken(tokens, newToken(returnType.stringValue));
		}
		
		addToken(tokens, newSpace());
		// block
		var block:IParserNode = ASTUtil.getNode(AS3NodeKind.BLOCK, node);
		build(block, tokens);
	}
	
	/**
	 * node is (import)
	 */
	private function buildImport(node:IParserNode, tokens:Vector.<Token>):void
	{
		addToken(tokens, newToken("import"));
		addToken(tokens, newSpace());
		addToken(tokens, newToken(node.stringValue));
		addToken(tokens, newSemiColumn());
		addToken(tokens, newNewLine());
	}
	
	/**
	 * node is (const)
	 */
	private function buildConstant(node:IParserNode, tokens:Vector.<Token>):void
	{
		// meta-list
		buildMetaList(node, tokens);
		// as-doc
		buildAsDoc(node, tokens);
		// modifiers
		buildModList(node, tokens);
		// var
		addToken(tokens, newToken(KeyWords.CONST));
		addToken(tokens, newSpace());
		var nit:IParserNode = node.getKind(AS3NodeKind.NAME_TYPE_INIT);
		// name
		var name:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, nit);
		addToken(tokens, newToken(name.stringValue));
		// type
		var type:IParserNode = ASTUtil.getNode(AS3NodeKind.TYPE, nit);
		if (type)
		{
			addToken(tokens, newColumn());
			addToken(tokens, newToken(type.stringValue));
		}
		// init
		var init:IParserNode = ASTUtil.getNode(AS3NodeKind.INIT, nit);
		if (init && init.numChildren > 0)
		{
			addToken(tokens, newSpace());
			addToken(tokens, newEquals());
			addToken(tokens, newSpace());
			addToken(tokens, newToken(init.getKind(AS3NodeKind.PRIMARY).stringValue));
		}
		addToken(tokens, newSemiColumn());
	}
	
	/**
	 * node is (var)
	 */
	private function buildAttribute(node:IParserNode, tokens:Vector.<Token>):void
	{
		// meta-list
		buildMetaList(node, tokens);
		// as-doc
		buildAsDoc(node, tokens);
		// modifiers
		buildModList(node, tokens);
		// var
		addToken(tokens, newToken(KeyWords.VAR));
		addToken(tokens, newSpace());
		var nit:IParserNode = node.getKind(AS3NodeKind.NAME_TYPE_INIT);
		// name
		var name:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, nit);
		addToken(tokens, newToken(name.stringValue));
		// type
		var type:IParserNode = ASTUtil.getNode(AS3NodeKind.TYPE, nit);
		if (type)
		{
			addToken(tokens, newColumn());
			addToken(tokens, newToken(type.stringValue));
		}
		// init
		var init:IParserNode = ASTUtil.getNode(AS3NodeKind.INIT, nit);
		if (init && init.numChildren > 0)
		{
			addToken(tokens, newSpace());
			addToken(tokens, newEquals());
			addToken(tokens, newSpace());
			addToken(tokens, newToken(init.getKind(AS3NodeKind.PRIMARY).stringValue));
		}
		addToken(tokens, newSemiColumn());
	}
	
	/**
	 * node is (get)
	 */
	private function buildGetter(node:IParserNode, tokens:Vector.<Token>):void
	{
		// as-doc
		buildAsDoc(node, tokens);
		if (state == AS3NodeKind.CLASS)
		{
			// modifiers
			buildModList(node, tokens);
		}
		// function
		addToken(tokens, newToken(KeyWords.FUNCTION));
		addToken(tokens, newSpace());
		addToken(tokens, newToken(KeyWords.GET));
		addToken(tokens, newSpace());
		// name
		var name:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, node);
		addToken(tokens, newToken(name.stringValue));
		// parameters [none]
		addToken(tokens, newLeftParenthesis());
		addToken(tokens, newRightParenthesis());
		// returnType
		var returnType:IParserNode = ASTUtil.getNode(AS3NodeKind.TYPE, node);
		if (returnType)
		{
			addToken(tokens, newColumn());
			addToken(tokens, newToken(returnType.stringValue));
		}
		if (state == AS3NodeKind.CLASS)
		{
			addToken(tokens, newSpace());
			// block
			var block:IParserNode = ASTUtil.getNode(AS3NodeKind.BLOCK, node);
			build(block, tokens);
		}
		else
		{
			addToken(tokens, newSemiColumn());
		}
	}
	
	/**
	 * node is (set)
	 */
	private function buildSetter(node:IParserNode, tokens:Vector.<Token>):void
	{
		// as-doc
		buildAsDoc(node, tokens);
		if (state == AS3NodeKind.CLASS)
		{
			// modifiers
			buildModList(node, tokens);
		}
		// function
		addToken(tokens, newToken(KeyWords.FUNCTION));
		addToken(tokens, newSpace());
		addToken(tokens, newToken(KeyWords.SET));
		addToken(tokens, newSpace());
		// name
		var name:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, node);
		addToken(tokens, newToken(name.stringValue));
		// param-list
		buildParamList(node, tokens);
		// returnType
		var returnType:IParserNode = ASTUtil.getNode(AS3NodeKind.TYPE, node);
		if (returnType)
		{
			addToken(tokens, newColumn());
			addToken(tokens, newToken(returnType.stringValue));
		}
		if (state == AS3NodeKind.CLASS)
		{
			addToken(tokens, newSpace());
			// block
			var block:IParserNode = ASTUtil.getNode(AS3NodeKind.BLOCK, node);
			build(block, tokens);
		}
		else
		{
			addToken(tokens, newSemiColumn());
		}
	}
	
	/**
	 * node is (function)
	 */
	private function buildFunction(node:IParserNode, tokens:Vector.<Token>):void
	{
		// as-doc
		buildAsDoc(node, tokens);
		if (state == AS3NodeKind.CLASS)
		{
			// modifiers
			buildModList(node, tokens);
		}
		// function
		addToken(tokens, newToken(KeyWords.FUNCTION));
		addToken(tokens, newSpace());
		// name
		var name:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, node);
		addToken(tokens, newToken(name.stringValue));
		// param-list
		buildParamList(node, tokens);
		// returnType
		var returnType:IParserNode = ASTUtil.getNode(AS3NodeKind.TYPE, node);
		if (returnType)
		{
			addToken(tokens, newColumn());
			addToken(tokens, newToken(returnType.stringValue));
		}
		if (state == AS3NodeKind.CLASS)
		{
			addToken(tokens, newSpace());
			// block
			var block:IParserNode = ASTUtil.getNode(AS3NodeKind.BLOCK, node);
			build(block, tokens);
		}
		else
		{
			addToken(tokens, newSemiColumn());
		}
	}
	
	/**
	 * node is (block)
	 */
	private function buildBlock(node:IParserNode, tokens:Vector.<Token>):void
	{
		
		var len:int = node.numChildren;
		
		for (var i:int = 0; i < len; i++)
		{
			var child:IParserNode = node.children[i];
			if (child.isKind("return"))
			{
				addToken(tokens, newToken("return"));
				addToken(tokens, newSpace());
				addToken(tokens, newToken(child.getKind("primary").stringValue));
				addToken(tokens, newSemiColumn());
			}
		}
	}
	
	/**
	 * node is (class|interface|function)
	 */
	private function buildAsDoc(node:IParserNode, tokens:Vector.<Token>):void
	{
		if (!hasComment(node))
			return;
		
		var asdoc:IParserNode = ASTUtil.getNode(AS3NodeKind.AS_DOC, node);
		var ast:IParserNode = asdoc.getLastChild();
		
		var element:IParserNode;
		var content:IParserNode = ast.getChild(0);
		var shortList:IParserNode = ASTUtil.getNode(ASDocNodeKind.SHORT_LIST, content);
		var longList:IParserNode = ASTUtil.getNode(ASDocNodeKind.LONG_LIST, content);
		var doctagList:IParserNode = ASTUtil.getNode(ASDocNodeKind.DOCTAG_LIST, content);
		
		addToken(tokens, newToken("/**"));
		addToken(tokens, newNewLine());
		// do short-list
		if (shortList && shortList.numChildren > 0)
		{
			addToken(tokens, newToken(" * "));
			for each (element in shortList.children)
			{
				addToken(tokens, newToken(element.stringValue));
			}
			addToken(tokens, newNewLine());
		}
		// do long-list
		if (longList && longList.numChildren > 0)
		{
			addToken(tokens, newToken(" * "));
			addToken(tokens, newNewLine());
			addToken(tokens, newToken(" * "));
			for each (element in longList.children)
			{
				addToken(tokens, newToken(element.stringValue));
			}
			addToken(tokens, newNewLine());
		}
		// do doctag-list
		if (doctagList && doctagList.numChildren > 0)
		{
			if(shortList && shortList.numChildren > 0)
			{
				addToken(tokens, newToken(" * "));
				addToken(tokens, newNewLine());
			}
			
			addToken(tokens, newToken(" * "));
			var len:int = doctagList.numChildren;
			for (var i:int = 0; i < len; i++)
			{
				element = doctagList.children[i] as IParserNode;
				
				var name:IParserNode = element.getChild(0);
				addToken(tokens, newToken("@"));
				addToken(tokens, newToken(name.stringValue));
				addToken(tokens, newSpace());
				if (element.numChildren > 1)
				{
					var body:IParserNode = element.getChild(1);
					addToken(tokens, newToken(body.getLastChild().stringValue));
				}
				addToken(tokens, newNewLine());
				if (i < len - 1)
					addToken(tokens, newToken(" * "));
			}
		}
		addToken(tokens, newToken(" */"));
		addToken(tokens, newNewLine());
	}
	
	/**
	 * node is (package)
	 */
	private function buildBlockDoc(node:IParserNode, tokens:Vector.<Token>):void
	{
		var blockDoc:IParserNode = node.getKind(AS3NodeKind.BLOCK_DOC);
		if (!blockDoc)
			return;
		
		addToken(tokens, newToken("/**"));
		addToken(tokens, newNewLine());
		addToken(tokens, newToken(" * "));
		addToken(tokens, newToken(blockDoc.stringValue));
		addToken(tokens, newNewLine());
		addToken(tokens, newToken(" */"));
		addToken(tokens, newNewLine());
	}
	
	/**
	 * @private
	 */
	private function hasComment(node:IParserNode):Boolean
	{
		var asdoc:IParserNode = ASTUtil.getNode(AS3NodeKind.AS_DOC, node);
		if (!asdoc)
			return false;
		
		var content:IParserNode = asdoc.getLastChild().getChild(0);
		
		var shortList:IParserNode = ASTUtil.getNode(ASDocNodeKind.SHORT_LIST, content);
		var longList:IParserNode = ASTUtil.getNode(ASDocNodeKind.LONG_LIST, content);
		var doctagList:IParserNode = ASTUtil.getNode(ASDocNodeKind.DOCTAG_LIST, content);
		
		return (shortList && shortList.numChildren > 0)
		|| (longList && longList.numChildren > 0)
			|| (doctagList && doctagList.numChildren > 0);
	}
	
	/**
	 * node is (class|interface|function)
	 */
	private function buildMetaList(node:IParserNode, tokens:Vector.<Token>):void
	{
		var metaList:IParserNode = ASTUtil.getNode(AS3NodeKind.META_LIST, node);
		if (!metaList || metaList.numChildren == 0)
			return;
		
		var len:int = metaList.numChildren;
		for (var i:int = 0; i < len; i++)
		{
			var child:IParserNode = metaList.children[i];
			var name:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, child);
			addToken(tokens, newLeftSquareBracket());
			addToken(tokens, newToken(name.stringValue));
			var paramList:IParserNode = ASTUtil.getNode(AS3NodeKind.PARAMETER_LIST, child);
			if (paramList && paramList.numChildren > 0)
			{
				addToken(tokens, newLeftParenthesis());
				var lenj:int = paramList.numChildren;
				for (var j:int = 0; j < lenj; j++)
				{
					var param:IParserNode = paramList.children[j];
					var pname:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, param);
					var pvalue:IParserNode = ASTUtil.getNode(AS3NodeKind.VALUE, param);
					if (pname)
					{
						addToken(tokens, newToken(pname.stringValue));
						addToken(tokens, newEquals());
					}
					if (pvalue)
					{
						addToken(tokens, newToken(pvalue.stringValue));
					}
					if (j < lenj - 1)
						addToken(tokens, newComma());
				}
				addToken(tokens, newRightParenthesis());
			}
			addToken(tokens, newRightSquareBracket());
			addToken(tokens, newNewLine());
		}
	}
	
	/**
	 * node is (class|interface|function)
	 */
	protected function buildModList(node:IParserNode, tokens:Vector.<Token>):void
	{
		var mods:IParserNode = ASTUtil.getNode(AS3NodeKind.MOD_LIST, node);
		if (mods && mods.numChildren > 0)
		{
			for each (var mod:IParserNode in mods.children)
			{
				addToken(tokens, newToken(mod.stringValue));
				addToken(tokens, newSpace());
			}
		}
	}
	
	/**
	 * node is (function)
	 */
	private function buildParamList(node:IParserNode, tokens:Vector.<Token>):void
	{
		addToken(tokens, newLeftParenthesis());
		var parameterList:IParserNode = ASTUtil.getNode(AS3NodeKind.PARAMETER_LIST, node);
		if (parameterList)
		{
			var len:int = parameterList.numChildren;
			for (var i:int = 0; i < len; i++)
			{
				var param:IParserNode = parameterList.children[i] as IParserNode;
				var nti:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME_TYPE_INIT, param);
				var rest:IParserNode = ASTUtil.getNode(AS3NodeKind.REST, param);
				if (nti)
				{
					var nameNode:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, nti);
					var typeNode:IParserNode = ASTUtil.getNode(AS3NodeKind.TYPE, nti);
					var initNode:IParserNode = ASTUtil.getNode(AS3NodeKind.INIT, nti);
					if (nameNode)
					{
						addToken(tokens, newToken(nameNode.stringValue));
					}
					if (typeNode)
					{
						addToken(tokens, newColumn());
						addToken(tokens, newToken(typeNode.stringValue));
					}
					if (initNode)
					{
						var primary:IParserNode = initNode.getChild(0);
						addToken(tokens, newSpace());
						addToken(tokens, newEquals());
						addToken(tokens, newSpace());
						addToken(tokens, newToken(primary.stringValue));
					}
				}
				else if (rest)
				{
					addToken(tokens, newRestParameters());
					addToken(tokens, newToken(rest.stringValue));
				}
				
				if (i < len - 1)
				{
					addToken(tokens, newComma());
					addToken(tokens, newSpace());
				}
			}
		}
		addToken(tokens, newRightParenthesis());
	}
	
	protected function buildContainerAfterStartNewline(node:IParserNode):Token
	{
		switch (node.kind)
		{
			case AS3NodeKind.CONTENT:
				lastToken = newNewLine();
				break;
			
			default:
				return null;
		}
		
		return lastToken;
	}
	
	protected function buildContainerBeforeStartNewline(node:IParserNode):Token
	{
		switch (node.kind)
		{
			case AS3NodeKind.CONTENT:
				if (breakPackageBracket && contentState == AS3NodeKind.PACKAGE)
				{
					lastToken = newNewLine();
					break;
				}
				if (breakTypeBracket 
					&& (contentState == AS3NodeKind.CLASS 
						|| contentState == AS3NodeKind.INTERFACE
						|| contentState == AS3NodeKind.FUNCTION))
				{
					lastToken = newNewLine();
					break;
				}
				else
				{
					return null;
				}
				
			case AS3NodeKind.BLOCK:
				if (breakBlockBracket)
				{
					lastToken = newNewLine();
					break;
				}
				else
				{
					return null;
				}
				
			default:
				return null;
		}
		
		return lastToken;
	}
	
	protected function buildContainerEndNewline(node:IParserNode):Token
	{
		switch (node.kind)
		{
			case AS3NodeKind.CONTENT:
				
				indent--;
				lastToken = newNewLine();
				break;
			
			case AS3NodeKind.BLOCK:
				
				indent--;
				lastToken = newNewLine();
				break;
			
			default:
				return null;
		}
		
		return lastToken;
	}
	
	protected function buildStartSpace(node:IParserNode):Token
	{
		switch (node.kind)
		{
			case AS3NodeKind.NAME:
				lastToken = newSpace();
				break;
			
			default:
				return null;
		}
		
		return lastToken;
	}
	
	protected function buildEndSpace(node:IParserNode):Token
	{
		switch (node.kind)
		{
			case AS3NodeKind.NAME:
				lastToken = newSpace();
				break;
			
			default:
				return null;
		}
		
		return lastToken;
	}
	
	protected function buildContainerStart(container:IParserNode):Token
	{
		switch (container.kind)
		{
			case AS3NodeKind.CONTENT:
			{
				lastToken = newLeftCurlyBracket();
				indent++;
				break;
			}
				
			case AS3NodeKind.BLOCK:
			{
				lastToken = newLeftCurlyBracket();
				indent++;
				break;
			}
				
			default:
				return null;
		}
		
		return lastToken;
	}
	
	protected function buildNode(node:IParserNode):Token
	{
		// TEMP fix for toplevel package being null
		var text:String = node.stringValue;
		if (text == null)
			text = "";
		
		switch (node.kind)
		{
			case AS3NodeKind.NAME:
				lastToken = newToken(text);
				break;
			
			case AS3NodeKind.MODIFIER:
				lastToken = newToken(text);
				break;
			
			default:
				return null;
		}
		
		return lastToken;
	}
	
	protected function buildContainerEnd(container:IParserNode):Token
	{
		switch (container.kind)
		{
			case AS3NodeKind.PACKAGE:
				state = AS3NodeKind.COMPILATION_UNIT;
				return null;
				
			case AS3NodeKind.CONTENT:
			{
				lastToken = newRightCurlyBracket();
				break;
			}
				
			case AS3NodeKind.BLOCK:
			{
				lastToken = newRightCurlyBracket();
				break;
			}
				
			default:
				return null;
		}
		
		return lastToken;
	}
	
	protected function addNewlinesBeforeMembers(ast:IParserNode, 
												tokens:Vector.<Token>):void
	{
		var len:int = newlinesBeforeMembers;
		for (var i:int = 0; i < len; i++)
		{
			addToken(tokens, newNewLine());
		}
	}
	
	protected function addNewlinesAfterMembers(ast:IParserNode, 
											   tokens:Vector.<Token>):void
	{
		var len:int = newlinesAfterMembers;
		for (var i:int = 0; i < len; i++)
		{
			addToken(tokens, newNewLine());
		}
	}
	
	protected function addToken(tokens:Vector.<Token>, token:Token):void
	{
		if (token)
		{
			tokens.push(token);
		}
		
		// start was correct
		if (token && token.text == "\n")
		{
			tokens.push(newLineIndent());
		}
	}
	
	protected function print(tokens:Vector.<Token>):String
	{
		var sb:String = "";
		
		for each (var element:Token in tokens) 
		{
			sb += element.text;
		}
		
		return sb;
	}
	
	public function newToken(text:String):Token
	{
		return Token.create(text, -1, -1);
	}
	
	// package
	public function newPackage():Token
	{
		return newToken(KeyWords.PACKAGE);
	}
	
	// class
	public function newClass():Token
	{
		return newToken(KeyWords.CLASS);
	}
	
	// interface
	public function newInterface():Token
	{
		return newToken(KeyWords.INTERFACE);
	}
	
	// {
	public function newLeftCurlyBracket():Token
	{
		return newToken(Operators.LEFT_CURLY_BRACKET);
	}
	
	// }
	public function newRightCurlyBracket():Token
	{
		return newToken(Operators.RIGHT_CURLY_BRACKET);
	}
	
	// "("
	public function newLeftParenthesis():Token
	{
		return newToken(Operators.LEFT_PARENTHESIS);
	}
	
	// ")"
	public function newRightParenthesis():Token
	{
		return newToken(Operators.RIGHT_PARENTHESIS);
	}
	
	// "["
	public function newLeftSquareBracket():Token
	{
		return newToken(Operators.LEFT_SQUARE_BRACKET);
	}
	
	// "]"
	public function newRightSquareBracket():Token
	{
		return newToken(Operators.RIGHT_SQUARE_BRACKET);
	}
	
	// "="
	public function newEquals():Token
	{
		return newToken(Operators.EQUAL);
	}
	
	// ","
	public function newComma():Token
	{
		return newToken(Operators.COMMA);
	}
	
	// ";"
	public function newSemiColumn():Token
	{
		return newToken(Operators.SEMI_COLUMN);
	}
	
	// ":"
	public function newColumn():Token
	{
		return newToken(Operators.COLUMN);
	}
	
	// "..."
	public function newRestParameters():Token
	{
		return newToken(Operators.REST_PARAMETERS);
	}
	
	
	// " "
	public function newSpace():Token
	{
		return newToken(" ");
	}
	
	// "    "
	public function newIndent():Token
	{
		return newToken("\t");
	}
	
	// "    [i]"
	public function newLineIndent():Token
	{
		var sb:String = "";
		var len:int = indent;
		for (var i:int = 0; i < len; i++)
		{
			// TODO make this configurable
			sb += "    "; // newIndent()
		}
		
		return newToken(sb);
	}
	
	// "\n"
	public function newNewLine():Token
	{
		return newToken("\n");
	}
	
	/**
	 * @private
	 */
	private static var _instance:BuilderFactory;
	
	/**
	 * Returns the single instance of the BuilderFactory.
	 */
	public static function get instance():BuilderFactory
	{
		if (!_instance)
			_instance = new BuilderFactory();
		return _instance;
	}
}
}
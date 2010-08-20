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
import org.teotigraphix.as3parser.core.Token;
import org.teotigraphix.as3parser.utils.ASTUtil;

/**
 * A class used to build actionscript3 class and interface source code.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class BuilderFactory
{
	//--------------------------------------------------------------------------
	//
	//  Public Static :: Properties
	//
	//--------------------------------------------------------------------------
	
	// TODO these are temp until I figure out configuration of indents and spaces
	
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
	private var lastToken:Token;
	
	//--------------------------------------------------------------------------
	//
	//  Protected :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  factory
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _factory:TokenFactory;
	
	/**
	 * The session token factory.
	 */
	public function get factory():TokenFactory
	{
		return _factory;
	}
	
	/**
	 * @private
	 */	
	public function set factory(value:TokenFactory):void
	{
		_factory = value;
	}
	
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
			|| value == AS3NodeKind.CLASS
			|| value == AS3NodeKind.INTERFACE
			|| value == AS3NodeKind.FUNCTION)
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
		
		factory = new TokenFactory();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	public function build(ast:IParserNode):String
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
		
		factory.reset();
		
		var tokens:Vector.<Token> = buildNodes(ast);
		
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
		return build(file.compilationNode.node);
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
		
		factory.reset();
		
		var tokens:Vector.<Token> = buildNodes(ast);
		
		return tokens;
	}
	
	/**
	 * @private
	 */	
	protected function buildNodes(ast:IParserNode, 
								  tokens:Vector.<Token> = null):Vector.<Token>
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
				else if (node.isKind(AS3NodeKind.INCLUDE))
				{
					buildInclude(node, tokens);
				}
				else if (node.isKind(AS3NodeKind.USE))
				{
					buildUse(node, tokens);
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
						addToken(tokens, factory.newNewLine());
				}
				else if (node.isKind(AS3NodeKind.VAR_LIST))
				{
					addNewlinesBeforeMembers(node, tokens);
					buildAttribute(node, tokens);
					addNewlinesAfterMembers(node, tokens);
					if (i < len - 1)
						addToken(tokens, factory.newNewLine());
				}
				else if (node.isKind(AS3NodeKind.GET))
				{
					addNewlinesBeforeMembers(node, tokens);
					buildGetter(node, tokens);
					addNewlinesAfterMembers(node, tokens);
					if (i < len - 1)
						addToken(tokens, factory.newNewLine());
				}
				else if (node.isKind(AS3NodeKind.SET))
				{
					addNewlinesBeforeMembers(node, tokens);
					buildSetter(node, tokens);
					addNewlinesAfterMembers(node, tokens);
					if (i < len - 1)
						addToken(tokens, factory.newNewLine());
				}
				else if (node.isKind(AS3NodeKind.FUNCTION))
				{
					addNewlinesBeforeMembers(node, tokens);
					buildFunction(node, tokens);
					addNewlinesAfterMembers(node, tokens);
					if (i < len - 1)
						addToken(tokens, factory.newNewLine());
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
					tokens = buildNodes(node, tokens);
				}
			}
		}
		
		if (ast.isKind(AS3NodeKind.BLOCK))
		{
			if (ast.numChildren > 0)
				addToken(tokens, factory.newNewLine());
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
	protected function buildPackage(node:IParserNode, tokens:Vector.<Token>):void
	{
		// block-doc
		buildBlockDoc(node, tokens);
		// package
		addToken(tokens, factory.newPackage());
		addToken(tokens, factory.newSpace());
		// name
		var name:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, node);
		if (name.stringValue && name.stringValue != null)
		{
			addToken(tokens, factory.newToken(name.stringValue));
			addToken(tokens, factory.newSpace());
		}
		
		// content
		buildNodes(node, tokens);
	}
	
	/**
	 * node is (class)
	 */
	protected function buildClassType(node:IParserNode, tokens:Vector.<Token>):void
	{
		state = AS3NodeKind.CLASS;
		// meta-list
		buildMetaList(node, tokens);
		// as-doc
		buildAsDoc(node, tokens);
		// modifiers
		buildModList(node, tokens);
		// class
		addToken(tokens, factory.newClass());
		addToken(tokens, factory.newSpace());
		// name
		var name:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, node);
		addToken(tokens, factory.newToken(name.stringValue));
		addToken(tokens, factory.newSpace());
		// extends
		var extendz:IParserNode = ASTUtil.getNode(AS3NodeKind.EXTENDS, node);
		if (extendz)
		{
			addToken(tokens, factory.newToken(KeyWords.EXTENDS));
			addToken(tokens, factory.newSpace());
			addToken(tokens, factory.newToken(extendz.stringValue));
			addToken(tokens, factory.newSpace());
		}
		// implements
		var impls:IParserNode = ASTUtil.getNode(AS3NodeKind.IMPLEMENTS_LIST, node);
		if (impls)
		{
			addToken(tokens, factory.newToken(KeyWords.IMPLEMENTS));
			addToken(tokens, factory.newSpace());
			var len:int = impls.numChildren;
			for (var i:int = 0; i < len; i++)
			{
				var impl:IParserNode = impls.children[i] as IParserNode;
				addToken(tokens, factory.newToken(impl.stringValue));
				if (i < len - 1)
					addToken(tokens, factory.newComma());
				addToken(tokens, factory.newSpace());
			}
		}
		// content
		var content:IParserNode = ASTUtil.getNode(AS3NodeKind.CONTENT, node);
		buildNodes(content, tokens);
	}
	
	/**
	 * node is (interface)
	 */
	protected function buildInterfaceType(node:IParserNode, tokens:Vector.<Token>):void
	{
		state = AS3NodeKind.INTERFACE;
		// modifiers
		buildModList(node, tokens);
		// interface
		addToken(tokens, factory.newInterface());
		addToken(tokens, factory.newSpace());
		// name
		var name:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, node);
		addToken(tokens, factory.newToken(name.stringValue));
		addToken(tokens, factory.newSpace());
		// extends
		var extendz:Vector.<IParserNode> = ASTUtil.getNodes(AS3NodeKind.EXTENDS, node);
		if (extendz && extendz.length > 0)
		{
			addToken(tokens, factory.newToken(KeyWords.EXTENDS));
			addToken(tokens, factory.newSpace());
			var len:int = extendz.length;
			for (var i:int = 0; i < len; i++)
			{
				var extend:IParserNode = extendz[i] as IParserNode;
				addToken(tokens, factory.newToken(extend.stringValue));
				if (i < len - 1)
					tokens.push(factory.newComma());
				addToken(tokens, factory.newSpace());
			}
		}
		// content
		var content:IParserNode = ASTUtil.getNode(AS3NodeKind.CONTENT, node);
		buildNodes(content, tokens);
	}
	
	/**
	 * node is (function) in package
	 */
	protected function buildFunctionType(node:IParserNode, tokens:Vector.<Token>):void
	{
		// as-doc
		buildAsDoc(node, tokens);
		// mod-list
		buildModList(node, tokens);
		// function
		addToken(tokens, factory.newToken(KeyWords.FUNCTION));
		addToken(tokens, factory.newSpace());
		// name
		var name:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, node);
		addToken(tokens, factory.newToken(name.stringValue));
		// param-list
		buildParamList(node, tokens);
		// returnType
		var returnType:IParserNode = ASTUtil.getNode(AS3NodeKind.TYPE, node);
		if (returnType)
		{
			addToken(tokens, factory.newColumn());
			addToken(tokens, factory.newToken(returnType.stringValue));
		}
		
		addToken(tokens, factory.newSpace());
		// block
		var block:IParserNode = ASTUtil.getNode(AS3NodeKind.BLOCK, node);
		buildNodes(block, tokens);
	}
	
	/**
	 * node is (import)
	 */
	protected function buildImport(node:IParserNode, tokens:Vector.<Token>):void
	{
		addToken(tokens, factory.newImport());
		addToken(tokens, factory.newSpace());
		addToken(tokens, factory.newToken(node.stringValue));
		addToken(tokens, factory.newSemiColumn());
		addToken(tokens, factory.newNewLine());
	}
	
	/**
	 * node is (include)
	 */
	protected function buildInclude(node:IParserNode, tokens:Vector.<Token>):void
	{
		addToken(tokens, factory.newInclude());
		addToken(tokens, factory.newSpace());
		addToken(tokens, factory.newSimpleQuote());
		addToken(tokens, factory.newToken(node.stringValue));
		addToken(tokens, factory.newSimpleQuote());
		addToken(tokens, factory.newNewLine());
	}
	
	/**
	 * node is (use)
	 */
	protected function buildUse(node:IParserNode, tokens:Vector.<Token>):void
	{
		addToken(tokens, factory.newUse());
		addToken(tokens, factory.newSpace());
		addToken(tokens, factory.newNamespace());
		addToken(tokens, factory.newSpace());
		addToken(tokens, factory.newToken(node.stringValue));
		addToken(tokens, factory.newSemiColumn());
		addToken(tokens, factory.newNewLine());
	}
	
	/**
	 * node is (const)
	 */
	protected function buildConstant(node:IParserNode, tokens:Vector.<Token>):void
	{
		// meta-list
		buildMetaList(node, tokens);
		// as-doc
		buildAsDoc(node, tokens);
		// modifiers
		buildModList(node, tokens);
		// var
		addToken(tokens, factory.newToken(KeyWords.CONST));
		addToken(tokens, factory.newSpace());
		var nit:IParserNode = node.getKind(AS3NodeKind.NAME_TYPE_INIT);
		// name
		var name:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, nit);
		addToken(tokens, factory.newToken(name.stringValue));
		// type
		var type:IParserNode = ASTUtil.getNode(AS3NodeKind.TYPE, nit);
		if (type)
		{
			addToken(tokens, factory.newColumn());
			addToken(tokens, factory.newToken(type.stringValue));
		}
		// init
		var init:IParserNode = ASTUtil.getNode(AS3NodeKind.INIT, nit);
		if (init && init.numChildren > 0)
		{
			addToken(tokens, factory.newSpace());
			addToken(tokens, factory.newEqual());
			addToken(tokens, factory.newSpace());
			addToken(tokens, factory.newToken(init.getKind(AS3NodeKind.PRIMARY).stringValue));
		}
		addToken(tokens, factory.newSemiColumn());
	}
	
	/**
	 * node is (var)
	 */
	protected function buildAttribute(node:IParserNode, tokens:Vector.<Token>):void
	{
		// meta-list
		buildMetaList(node, tokens);
		// as-doc
		buildAsDoc(node, tokens);
		// modifiers
		buildModList(node, tokens);
		// var
		addToken(tokens, factory.newToken(KeyWords.VAR));
		addToken(tokens, factory.newSpace());
		var nit:IParserNode = node.getKind(AS3NodeKind.NAME_TYPE_INIT);
		// name
		var name:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, nit);
		addToken(tokens, factory.newToken(name.stringValue));
		// type
		var type:IParserNode = ASTUtil.getNode(AS3NodeKind.TYPE, nit);
		if (type)
		{
			addToken(tokens, factory.newColumn());
			addToken(tokens, factory.newToken(type.stringValue));
		}
		// init
		var init:IParserNode = ASTUtil.getNode(AS3NodeKind.INIT, nit);
		if (init && init.numChildren > 0)
		{
			addToken(tokens, factory.newSpace());
			addToken(tokens, factory.newEqual());
			addToken(tokens, factory.newSpace());
			addToken(tokens, factory.newToken(init.getKind(AS3NodeKind.PRIMARY).stringValue));
		}
		addToken(tokens, factory.newSemiColumn());
	}
	
	/**
	 * node is (get)
	 */
	protected function buildGetter(node:IParserNode, tokens:Vector.<Token>):void
	{
		// meta-list
		buildMetaList(node, tokens);
		// as-doc
		buildAsDoc(node, tokens);
		if (state == AS3NodeKind.CLASS)
		{
			// modifiers
			buildModList(node, tokens);
		}
		// function
		addToken(tokens, factory.newToken(KeyWords.FUNCTION));
		addToken(tokens, factory.newSpace());
		addToken(tokens, factory.newToken(KeyWords.GET));
		addToken(tokens, factory.newSpace());
		// name
		var name:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, node);
		addToken(tokens, factory.newToken(name.stringValue));
		// parameters [none]
		addToken(tokens, factory.newLeftParenthesis());
		addToken(tokens, factory.newRightParenthesis());
		// returnType
		var returnType:IParserNode = ASTUtil.getNode(AS3NodeKind.TYPE, node);
		if (returnType)
		{
			addToken(tokens, factory.newColumn());
			addToken(tokens, factory.newToken(returnType.stringValue));
		}
		if (state == AS3NodeKind.CLASS)
		{
			addToken(tokens, factory.newSpace());
			// block
			var block:IParserNode = ASTUtil.getNode(AS3NodeKind.BLOCK, node);
			buildNodes(block, tokens);
		}
		else
		{
			addToken(tokens, factory.newSemiColumn());
		}
	}
	
	/**
	 * node is (set)
	 */
	protected function buildSetter(node:IParserNode, tokens:Vector.<Token>):void
	{
		// meta-list
		buildMetaList(node, tokens);
		// as-doc
		buildAsDoc(node, tokens);
		if (state == AS3NodeKind.CLASS)
		{
			// modifiers
			buildModList(node, tokens);
		}
		// function
		addToken(tokens, factory.newToken(KeyWords.FUNCTION));
		addToken(tokens, factory.newSpace());
		addToken(tokens, factory.newToken(KeyWords.SET));
		addToken(tokens, factory.newSpace());
		// name
		var name:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, node);
		addToken(tokens, factory.newToken(name.stringValue));
		// param-list
		buildParamList(node, tokens);
		// returnType
		var returnType:IParserNode = ASTUtil.getNode(AS3NodeKind.TYPE, node);
		if (returnType)
		{
			addToken(tokens, factory.newColumn());
			addToken(tokens, factory.newToken(returnType.stringValue));
		}
		if (state == AS3NodeKind.CLASS)
		{
			addToken(tokens, factory.newSpace());
			// block
			var block:IParserNode = ASTUtil.getNode(AS3NodeKind.BLOCK, node);
			buildNodes(block, tokens);
		}
		else
		{
			addToken(tokens, factory.newSemiColumn());
		}
	}
	
	/**
	 * node is (function)
	 */
	protected function buildFunction(node:IParserNode, tokens:Vector.<Token>):void
	{
		// meta-list
		buildMetaList(node, tokens);
		// as-doc
		buildAsDoc(node, tokens);
		if (state == AS3NodeKind.CLASS)
		{
			// modifiers
			buildModList(node, tokens);
		}
		// function
		addToken(tokens, factory.newToken(KeyWords.FUNCTION));
		addToken(tokens, factory.newSpace());
		// name
		var name:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, node);
		addToken(tokens, factory.newToken(name.stringValue));
		// param-list
		buildParamList(node, tokens);
		// returnType
		var returnType:IParserNode = ASTUtil.getNode(AS3NodeKind.TYPE, node);
		if (returnType)
		{
			addToken(tokens, factory.newColumn());
			addToken(tokens, factory.newToken(returnType.stringValue));
		}
		if (state == AS3NodeKind.CLASS)
		{
			addToken(tokens, factory.newSpace());
			// block
			var block:IParserNode = ASTUtil.getNode(AS3NodeKind.BLOCK, node);
			buildNodes(block, tokens);
		}
		else
		{
			addToken(tokens, factory.newSemiColumn());
		}
	}
	
	/**
	 * node is (block)
	 */
	protected function buildBlock(node:IParserNode, tokens:Vector.<Token>):void
	{
		
		var len:int = node.numChildren;
		
		for (var i:int = 0; i < len; i++)
		{
			var child:IParserNode = node.children[i];
			if (child.isKind(AS3NodeKind.RETURN))
			{
				addToken(tokens, factory.newReturn());
				addToken(tokens, factory.newSpace());
				addToken(tokens, factory.newToken(child.getKind(AS3NodeKind.PRIMARY).stringValue));
				addToken(tokens, factory.newSemiColumn());
			}
		}
	}
	
	/**
	 * node is (class|interface|function)
	 */
	protected function buildAsDoc(node:IParserNode, tokens:Vector.<Token>):void
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
		
		addToken(tokens, factory.newToken("/**"));
		addToken(tokens, factory.newNewLine());
		// do short-list
		if (shortList && shortList.numChildren > 0)
		{
			addToken(tokens, factory.newToken(" * "));
			for each (element in shortList.children)
			{
				addToken(tokens, factory.newToken(element.stringValue));
			}
			addToken(tokens, factory.newNewLine());
		}
		// do long-list
		if (longList && longList.numChildren > 0)
		{
			addToken(tokens, factory.newToken(" * "));
			addToken(tokens, factory.newNewLine());
			addToken(tokens, factory.newToken(" * "));
			for each (element in longList.children)
			{
				addToken(tokens, factory.newToken(element.stringValue));
			}
			addToken(tokens, factory.newNewLine());
		}
		// do doctag-list
		if (doctagList && doctagList.numChildren > 0)
		{
			if(shortList && shortList.numChildren > 0)
			{
				addToken(tokens, factory.newToken(" * "));
				addToken(tokens, factory.newNewLine());
			}
			
			addToken(tokens, factory.newToken(" * "));
			var len:int = doctagList.numChildren;
			for (var i:int = 0; i < len; i++)
			{
				element = doctagList.children[i] as IParserNode;
				
				var name:IParserNode = element.getChild(0);
				addToken(tokens, factory.newToken("@"));
				addToken(tokens, factory.newToken(name.stringValue));
				addToken(tokens, factory.newSpace());
				if (element.numChildren > 1)
				{
					var body:IParserNode = element.getChild(1);
					addToken(tokens, factory.newToken(body.getLastChild().stringValue));
				}
				addToken(tokens, factory.newNewLine());
				if (i < len - 1)
					addToken(tokens, factory.newToken(" * "));
			}
		}
		addToken(tokens, factory.newToken(" */"));
		addToken(tokens, factory.newNewLine());
	}
	
	/**
	 * node is (package)
	 */
	protected function buildBlockDoc(node:IParserNode, tokens:Vector.<Token>):void
	{
		var blockDoc:IParserNode = node.getKind(AS3NodeKind.BLOCK_DOC);
		if (!blockDoc)
			return;
		
		addToken(tokens, factory.newToken("/**"));
		addToken(tokens, factory.newNewLine());
		addToken(tokens, factory.newToken(" * "));
		addToken(tokens, factory.newToken(blockDoc.stringValue));
		addToken(tokens, factory.newNewLine());
		addToken(tokens, factory.newToken(" */"));
		addToken(tokens, factory.newNewLine());
	}
	
	/**
	 * @private
	 */
	protected function hasComment(node:IParserNode):Boolean
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
	protected function buildMetaList(node:IParserNode, tokens:Vector.<Token>):void
	{
		var metaList:IParserNode = ASTUtil.getNode(AS3NodeKind.META_LIST, node);
		if (!metaList || metaList.numChildren == 0)
			return;
		
		var len:int = metaList.numChildren;
		for (var i:int = 0; i < len; i++)
		{
			var child:IParserNode = metaList.children[i];
			// as-doc
			buildAsDoc(child, tokens);
			// meta
			var name:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, child);
			// FIXME 
			if (!name)
			{
				name = child;
			}
			addToken(tokens, factory.newLeftSquareBracket());
			addToken(tokens, factory.newToken(name.stringValue));
			var paramList:IParserNode = ASTUtil.getNode(AS3NodeKind.PARAMETER_LIST, child);
			if (paramList && paramList.numChildren > 0)
			{
				addToken(tokens, factory.newLeftParenthesis());
				var lenj:int = paramList.numChildren;
				for (var j:int = 0; j < lenj; j++)
				{
					var param:IParserNode = paramList.children[j];
					var pname:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, param);
					var pvalue:IParserNode = ASTUtil.getNode(AS3NodeKind.VALUE, param);
					if (pname)
					{
						addToken(tokens, factory.newToken(pname.stringValue));
						addToken(tokens, factory.newEqual());
					}
					if (pvalue)
					{
						addToken(tokens, factory.newToken(pvalue.stringValue));
					}
					if (j < lenj - 1)
						addToken(tokens, factory.newComma());
				}
				addToken(tokens, factory.newRightParenthesis());
			}
			addToken(tokens, factory.newRightSquareBracket());
			addToken(tokens, factory.newNewLine());
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
				addToken(tokens, factory.newToken(mod.stringValue));
				addToken(tokens, factory.newSpace());
			}
		}
	}
	
	/**
	 * node is (function)
	 */
	protected function buildParamList(node:IParserNode, tokens:Vector.<Token>):void
	{
		addToken(tokens, factory.newLeftParenthesis());
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
						addToken(tokens, factory.newToken(nameNode.stringValue));
					}
					if (typeNode)
					{
						addToken(tokens, factory.newColumn());
						addToken(tokens, factory.newToken(typeNode.stringValue));
					}
					if (initNode)
					{
						var primary:IParserNode = initNode.getChild(0);
						addToken(tokens, factory.newSpace());
						addToken(tokens, factory.newEqual());
						addToken(tokens, factory.newSpace());
						addToken(tokens, factory.newToken(primary.stringValue));
					}
				}
				else if (rest)
				{
					addToken(tokens, factory.newRestParameters());
					addToken(tokens, factory.newToken(rest.stringValue));
				}
				
				if (i < len - 1)
				{
					addToken(tokens, factory.newComma());
					addToken(tokens, factory.newSpace());
				}
			}
		}
		addToken(tokens, factory.newRightParenthesis());
	}
	
	protected function buildContainerAfterStartNewline(node:IParserNode):Token
	{
		switch (node.kind)
		{
			case AS3NodeKind.CONTENT:
				lastToken = factory.newNewLine();
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
					lastToken = factory.newNewLine();
					break;
				}
				if (breakTypeBracket 
					&& (contentState == AS3NodeKind.CLASS 
						|| contentState == AS3NodeKind.INTERFACE
						|| contentState == AS3NodeKind.FUNCTION))
				{
					lastToken = factory.newNewLine();
					break;
				}
				else
				{
					return null;
				}
				
			case AS3NodeKind.BLOCK:
				if (breakBlockBracket)
				{
					lastToken = factory.newNewLine();
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
				
				factory.popIndent();
				lastToken = factory.newNewLine();
				break;
			
			case AS3NodeKind.BLOCK:
				
				factory.popIndent();
				lastToken = factory.newNewLine();
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
				lastToken = factory.newSpace();
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
				lastToken = factory.newSpace();
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
				lastToken = factory.newLeftCurlyBracket();
				factory.pushIndent();
				break;
			}
				
			case AS3NodeKind.BLOCK:
			{
				lastToken = factory.newLeftCurlyBracket();
				factory.pushIndent();
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
				lastToken = factory.newToken(text);
				break;
			
			case AS3NodeKind.MODIFIER:
				lastToken = factory.newToken(text);
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
				lastToken = factory.newRightCurlyBracket();
				break;
			}
				
			case AS3NodeKind.BLOCK:
			{
				lastToken = factory.newRightCurlyBracket();
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
			addToken(tokens, factory.newNewLine());
		}
	}
	
	protected function addNewlinesAfterMembers(ast:IParserNode, 
											   tokens:Vector.<Token>):void
	{
		var len:int = newlinesAfterMembers;
		for (var i:int = 0; i < len; i++)
		{
			addToken(tokens, factory.newNewLine());
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
			tokens.push(factory.newLineIndent());
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
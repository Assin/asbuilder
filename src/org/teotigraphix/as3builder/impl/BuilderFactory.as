package org.teotigraphix.as3builder.impl
{

import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.ASDocNodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.api.KeyWords;
import org.teotigraphix.as3parser.api.Operators;
import org.teotigraphix.as3parser.core.Token;
import org.teotigraphix.as3parser.utils.ASTUtil;

public class BuilderFactory
{
	public function BuilderFactory()
	{
	}
	
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
		
		var tokens:Vector.<Token> = build(ast);
		
		for each (var token:Token in tokens)
		{
			sb += token.text;
		}
		
		return sb;
	}
	
	private var indent:int = 0;
	
	private var lastToken:Token;
	
	//----------------------------------
	//  state
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _state:String;
	
	/**
	 * doc
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
			||value == AS3NodeKind.INTERFACE)
		{
			_state = value;
		}
	}
	
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
				else if (node.isKind(AS3NodeKind.CLASS))
				{
					buildClass(node, tokens);
				}
				else if (node.isKind(AS3NodeKind.INTERFACE))
				{
					buildInterface(node, tokens);
				}
				else if (node.isKind(AS3NodeKind.FUNCTION))
				{
					buildFunction(node, tokens);
					if (i < len - 1)
						addToken(tokens, newNewLine());
				}
				else
				{
					tokens = build(node, tokens);
				}
			}
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
	 * node is (function)
	 */
	private function buildFunction(node:IParserNode, tokens:Vector.<Token>):void
	{
		// as-doc
		buildAsDoc(node, tokens);
		if (state == AS3NodeKind.CLASS)
		{
			// modifiers
			buildModifiers(node, tokens);
		}
		// function
		tokens.push(newToken(KeyWords.FUNCTION));
		tokens.push(newSpace());
		// name
		var name:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, node);
		tokens.push(newToken(name.stringValue));
		// parameters
		tokens.push(newToken("("));
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
						tokens.push(newToken(nameNode.stringValue));
					}
					if (typeNode)
					{
						tokens.push(newToken(":"));
						tokens.push(newToken(typeNode.stringValue));
					}
					if (initNode)
					{
						var primary:IParserNode = initNode.getChild(0);
						tokens.push(newSpace());
						tokens.push(newToken("="));
						tokens.push(newSpace());
						tokens.push(newToken(primary.stringValue));
					}
				}
				else if (rest)
				{
					tokens.push(newToken("..."));
					tokens.push(newToken(rest.stringValue));
				}
				
				if (i < len - 1)
				{
					tokens.push(newToken(","));
					tokens.push(newSpace());
				}
			}
		}
		tokens.push(newToken(")"));
		// returnType
		var returnType:IParserNode = ASTUtil.getNode(AS3NodeKind.TYPE, node);
		if (returnType)
		{
			tokens.push(newToken(":"));
			tokens.push(newToken(returnType.stringValue));
		}
		if (state == AS3NodeKind.CLASS)
		{
			tokens.push(newSpace());
			// block
			var block:IParserNode = ASTUtil.getNode(AS3NodeKind.BLOCK, node);
			build(block, tokens);
		}
		else
		{
			tokens.push(newToken(";"));
		}
	}
	
	private function buildPackage(node:IParserNode, tokens:Vector.<Token>):void
	{
		// package
		tokens.push(newPackage());
		tokens.push(newSpace());
		// name
		var name:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, node);
		if (name.stringValue != null)
		{
			tokens.push(newToken(name.stringValue));
			tokens.push(newSpace());
		}
		
		// content
		build(node, tokens);
	}
	
	private function buildAsDoc(node:IParserNode, tokens:Vector.<Token>):void
	{
		var asdoc:IParserNode = ASTUtil.getNode(AS3NodeKind.AS_DOC, node);
		if (!asdoc)
			return;
		
		//var ast:IParserNode = ParserFactory.instance.asdocParser.
		//	buildAst(Vector.<String>(asdoc.stringValue.split("\n")), "internal");
		
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
				addToken(tokens, newToken(" "));
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
			tokens.push(newToken("["));
			tokens.push(newToken(name.stringValue));
			tokens.push(newToken("]"));
			addToken(tokens, newNewLine());
		}
	}
	
	private function buildClass(node:IParserNode, tokens:Vector.<Token>):void
	{
		state = AS3NodeKind.CLASS;
		// meta-list
		buildMetaList(node, tokens);
		// as-doc
		buildAsDoc(node, tokens);
		// modifiers
		buildModifiers(node, tokens);
		// class
		tokens.push(newClass());
		tokens.push(newSpace());
		// name
		var name:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, node);
		tokens.push(newToken(name.stringValue));
		tokens.push(newSpace());
		// extends
		var extendz:IParserNode = ASTUtil.getNode(AS3NodeKind.EXTENDS, node);
		if (extendz)
		{
			tokens.push(newToken(KeyWords.EXTENDS));
			tokens.push(newSpace());
			tokens.push(newToken(extendz.stringValue));
			tokens.push(newSpace());
		}
		// implements
		var impls:IParserNode = ASTUtil.getNode(AS3NodeKind.IMPLEMENTS_LIST, node);
		if (impls)
		{
			tokens.push(newToken(KeyWords.IMPLEMENTS));
			tokens.push(newSpace());
			var len:int = impls.numChildren;
			for (var i:int = 0; i < len; i++)
			{
				var impl:IParserNode = impls.children[i] as IParserNode;
				tokens.push(newToken(impl.stringValue));
				if (i < len - 1)
					tokens.push(newToken(","));
				tokens.push(newSpace());
			}
		}
		// content
		var content:IParserNode = ASTUtil.getNode(AS3NodeKind.CONTENT, node);
		build(content, tokens);
	}
	
	private function buildInterface(node:IParserNode, tokens:Vector.<Token>):void
	{
		state = AS3NodeKind.INTERFACE;
		
		// modifiers
		buildModifiers(node, tokens);
		// interface
		tokens.push(newInterface());
		tokens.push(newSpace());
		// name
		var name:IParserNode = ASTUtil.getNode(AS3NodeKind.NAME, node);
		tokens.push(newToken(name.stringValue));
		tokens.push(newSpace());
		// extends
		var extendz:Vector.<IParserNode> = ASTUtil.getNodes(AS3NodeKind.EXTENDS, node);
		if (extendz && extendz.length > 0)
		{
			tokens.push(newToken(KeyWords.EXTENDS));
			tokens.push(newSpace());
			var len:int = extendz.length;
			for (var i:int = 0; i < len; i++)
			{
				var extend:IParserNode = extendz[i] as IParserNode;
				tokens.push(newToken(extend.stringValue));
				if (i < len - 1)
					tokens.push(newToken(","));
				tokens.push(newSpace());
			}
		}
		// content
		var content:IParserNode = ASTUtil.getNode(AS3NodeKind.CONTENT, node);
		build(content, tokens);
	}
	
	
	protected function buildModifiers(node:IParserNode, tokens:Vector.<Token>):void
	{
		var mods:IParserNode = ASTUtil.getNode(AS3NodeKind.MOD_LIST, node);
		if (mods)
		{
			for each (var mod:IParserNode in mods.children)
			{
				tokens.push(newToken(mod.stringValue));
				tokens.push(newSpace());
			}
		}
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
			//case AS3NodeKind.CONTENT:
			//	lastToken = newNewLine();
			//	break;
			
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
		trace("buildContainerStart(", container.kind, ")");
		
		switch (container.kind)
		{
			case AS3NodeKind.PACKAGE:
				//lastToken = newPackage();
				//break;
				return null;
				
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
		trace("buildNode(", node.kind, ")");
		
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
		trace("buildContainerEnd(", container.kind, ")");
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
	
	public function newLineIndent():Token
	{
		var sb:String = "";
		var len:int = indent;
		for (var i:int = 0; i < len; i++)
		{
			sb += "    ";
		}
		
		return newToken(sb);
	}
	
	// "\n"
	public function newNewLine():Token
	{
		return newToken("\n");
	}
	
	[Test]
	public function testBuilder():void
	{
		//build();
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
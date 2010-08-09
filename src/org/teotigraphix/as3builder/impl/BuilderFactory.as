package org.teotigraphix.as3builder.impl
{

import org.teotigraphix.as3nodes.api.IParameterNode;
import org.teotigraphix.as3parser.api.AS3NodeKind;
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
			||value == AS3NodeKind.CLASS)
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
		
		if (ast.numChildren > 0)
		{
			for each (var node:IParserNode in ast.children)
			{
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
		}
		
		// content
		build(node, tokens);
	}
	
	private function buildClass(node:IParserNode, tokens:Vector.<Token>):void
	{
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
	
	
	protected function buildPackageNodeFooter():Vector.<Token>
	{
		var tokens:Vector.<Token> = new Vector.<Token>();
		tokens.push(newNewLine());
		tokens.push(newRightCurlyBracket());
		return tokens;
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
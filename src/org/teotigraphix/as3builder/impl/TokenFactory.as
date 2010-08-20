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

import org.teotigraphix.as3parser.api.IToken;
import org.teotigraphix.as3parser.api.KeyWords;
import org.teotigraphix.as3parser.api.Operators;
import org.teotigraphix.as3parser.core.Token;

/**
 * A token factory for KeyWords, Operators and other various tokens.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TokenFactory
{
	//--------------------------------------------------------------------------
	//
	//  Public :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  indent
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _indent:int;
	
	/**
	 * The current factory indent.
	 */
	public function get indent():int
	{
		return _indent;
	}
	
	/**
	 * @private
	 */	
	public function set indent(value:int):void
	{
		_indent = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function TokenFactory()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Resets the factory state.
	 */
	public function reset():void
	{
		_indent = 0;
	}
	
	/**
	 * Pushes an indent that affects <code>newIndent()</code> and 
	 * <code>newLineIndent()</code>.
	 */
	public function pushIndent():void
	{
		_indent++;
	}
	
	/**
	 * Pops an indent that affects <code>newIndent()</code> and 
	 * <code>newLineIndent()</code>.
	 */
	public function popIndent():void
	{
		_indent--;
	}
	
	/**
	 * Returns a new <code>IToken</code>.
	 * 
	 * @param text The String token text.
	 * @return A <code>IToken</code> with the token text String.
	 */
	public function newToken(text:String):IToken
	{
		return new Token(text, -1, -1);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public KeyWords :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Returns <code>KeyWords.AS</code> token.
	 */
	public final function newAs():IToken
	{
		return newToken(KeyWords.AS);
	}
	
	/**
	 * Returns <code>KeyWords.CASE</code> token.
	 */
	public final function newCase():IToken
	{
		return newToken(KeyWords.CASE);
	}
	
	/**
	 * Returns <code>KeyWords.CATCH</code> token.
	 */
	public final function newCatch():IToken
	{
		return newToken(KeyWords.CATCH);
	}
	
	/**
	 * Returns <code>KeyWords.CLASS</code> token.
	 */
	public final function newClass():IToken
	{
		return newToken(KeyWords.CLASS);
	}
	
	/**
	 * Returns <code>KeyWords.CONST</code> token.
	 */
	public final function newConst():IToken
	{
		return newToken(KeyWords.CONST);
	}
	
	/**
	 * Returns <code>KeyWords.DEFAULT</code> token.
	 */
	public final function newDefault():IToken
	{
		return newToken(KeyWords.DEFAULT);
	}
	
	/**
	 * Returns <code>KeyWords.DELETE</code> token.
	 */
	public final function newDelete():IToken
	{
		return newToken(KeyWords.DELETE);
	}
	
	/**
	 * Returns <code>KeyWords.DO</code> token.
	 */
	public final function newDo():IToken
	{
		return newToken(KeyWords.DO);
	}
	
	/**
	 * Returns <code>KeyWords.DYNAMIC</code> token.
	 */
	public final function newDynamic():IToken
	{
		return newToken(KeyWords.DYNAMIC);
	}
	
	/**
	 * Returns <code>KeyWords.EACH</code> token.
	 */
	public final function newEach():IToken
	{
		return newToken(KeyWords.EACH);
	}
	
	/**
	 * Returns <code>KeyWords.ELSE</code> token.
	 */
	public final function newElse():IToken
	{
		return newToken(KeyWords.ELSE);
	}
	
	/**
	 * Returns <code>KeyWords.EOF</code> token.
	 */
	public final function newEOF():IToken
	{
		return newToken(KeyWords.EOF);
	}
	
	/**
	 * Returns <code>KeyWords.EXTENDS</code> token.
	 */
	public final function newExtends():IToken
	{
		return newToken(KeyWords.EXTENDS);
	}
	
	/**
	 * Returns <code>KeyWords.FINAL</code> token.
	 */
	public final function newFinal():IToken
	{
		return newToken(KeyWords.FINAL);
	}
	
	/**
	 * Returns <code>KeyWords.FINALLY</code> token.
	 */
	public final function newFinally():IToken
	{
		return newToken(KeyWords.FINALLY);
	}
	
	/**
	 * Returns <code>KeyWords.FOR</code> token.
	 */
	public final function newFor():IToken
	{
		return newToken(KeyWords.FOR);
	}
	
	/**
	 * Returns <code>KeyWords.FUNCTION</code> token.
	 */
	public final function newFunction():IToken
	{
		return newToken(KeyWords.FUNCTION);
	}
	
	/**
	 * Returns <code>KeyWords.GET</code> token.
	 */
	public final function newGet():IToken
	{
		return newToken(KeyWords.GET);
	}
	
	/**
	 * Returns <code>KeyWords.IF</code> token.
	 */
	public final function newIf():IToken
	{
		return newToken(KeyWords.IF);
	}
	
	/**
	 * Returns <code>KeyWords.IMPLEMENTS</code> token.
	 */
	public final function newImplements():IToken
	{
		return newToken(KeyWords.IMPLEMENTS);
	}
	
	/**
	 * Returns <code>KeyWords.IMPORT</code> token.
	 */
	public final function newImport():IToken
	{
		return newToken(KeyWords.IMPORT);
	}
	
	/**
	 * Returns <code>KeyWords.IN</code> token.
	 */
	public final function newIn():IToken
	{
		return newToken(KeyWords.IN);
	}
	
	/**
	 * Returns <code>KeyWords.INCLUDE</code> token.
	 */
	public final function newInclude():IToken
	{
		return newToken(KeyWords.INCLUDE);
	}
	
	/**
	 * Returns <code>KeyWords.INSTANCE_OF</code> token.
	 */
	public final function newInstanceOf():IToken
	{
		return newToken(KeyWords.INSTANCE_OF);
	}
	
	/**
	 * Returns <code>KeyWords.INTERFACE</code> token.
	 */
	public final function newInterface():IToken
	{
		return newToken(KeyWords.INTERFACE);
	}
	
	/**
	 * Returns <code>KeyWords.INTERNAL</code> token.
	 */
	public final function newInternal():IToken
	{
		return newToken(KeyWords.INTERNAL);
	}
	
	/**
	 * Returns <code>KeyWords.IS</code> token.
	 */
	public final function newIs():IToken
	{
		return newToken(KeyWords.IS);
	}
	
	/**
	 * Returns <code>KeyWords.NAMESPACE</code> token.
	 */
	public final function newNamespace():IToken
	{
		return newToken(KeyWords.NAMESPACE);
	}
	
	/**
	 * Returns <code>KeyWords.NEW</code> token.
	 */
	public final function newNew():IToken
	{
		return newToken(KeyWords.NEW);
	}
	
	/**
	 * Returns <code>KeyWords.OVERRIDE</code> token.
	 */
	public final function newOverride():IToken
	{
		return newToken(KeyWords.OVERRIDE);
	}
	
	/**
	 * Returns <code>KeyWords.PACKAGE</code> token.
	 */
	public final function newPackage():IToken
	{
		return newToken(KeyWords.PACKAGE);
	}
	
	/**
	 * Returns <code>KeyWords.PRIVATE</code> token.
	 */
	public final function newPrivate():IToken
	{
		return newToken(KeyWords.PRIVATE);
	}
	
	/**
	 * Returns <code>KeyWords.PROTECTED</code> token.
	 */
	public final function newProtected():IToken
	{
		return newToken(KeyWords.PROTECTED);
	}
	
	/**
	 * Returns <code>KeyWords.public final</code> token.
	 */
	public final function newPublic():IToken
	{
		return newToken(KeyWords.PUBLIC);
	}
	
	/**
	 * Returns <code>KeyWords.RETURN</code> token.
	 */
	public final function newReturn():IToken
	{
		return newToken(KeyWords.RETURN);
	}
	
	/**
	 * Returns <code>KeyWords.SET</code> token.
	 */
	public final function newSet():IToken
	{
		return newToken(KeyWords.SET);
	}
	
	/**
	 * Returns <code>KeyWords.STATIC</code> token.
	 */
	public final function newStatic():IToken
	{
		return newToken(KeyWords.STATIC);
	}
	
	/**
	 * Returns <code>KeyWords.SUPER</code> token.
	 */
	public final function newSuper():IToken
	{
		return newToken(KeyWords.SUPER);
	}
	
	/**
	 * Returns <code>KeyWords.SWITCH</code> token.
	 */
	public final function newSwitch():IToken
	{
		return newToken(KeyWords.SWITCH);
	}
	
	/**
	 * Returns <code>KeyWords.TRY</code> token.
	 */
	public final function newTry():IToken
	{
		return newToken(KeyWords.TRY);
	}
	
	/**
	 * Returns <code>KeyWords.TYPEOF</code> token.
	 */
	public final function newTypeof():IToken
	{
		return newToken(KeyWords.TYPEOF);
	}
	
	/**
	 * Returns <code>KeyWords.USE</code> token.
	 */
	public final function newUse():IToken
	{
		return newToken(KeyWords.USE);
	}
	
	/**
	 * Returns <code>KeyWords.VAR</code> token.
	 */
	public final function newVar():IToken
	{
		return newToken(KeyWords.VAR);
	}
	
	/**
	 * Returns <code>KeyWords.VOID</code> token.
	 */
	public final function newVoid():IToken
	{
		return newToken(KeyWords.VOID);
	}
	
	/**
	 * Returns <code>KeyWords.WHILE</code> token.
	 */
	public final function newWhile():IToken
	{
		return newToken(KeyWords.WHILE);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public KeyWords :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Returns <code>Operators.AND</code>; <code>&&</code> token.
	 */
	public final function newAnd():IToken
	{
		return newToken(Operators.AND);
	}
	
	/**
	 * Returns <code>Operators.AND_EQUAL</code>; <code>&=</code> token.
	 */
	public final function newAndEqual():IToken
	{
		return newToken(Operators.AND_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.AT</code>; <code>@</code> token.
	 */
	public final function newAt():IToken
	{
		return newToken(Operators.AT);
	}
	
	/**
	 * Returns <code>Operators.B_AND</code>; <code>&</code> token.
	 */
	public final function newBAnd():IToken
	{
		return newToken(Operators.B_AND);
	}
	
	/**
	 * Returns <code>Operators.B_OR</code>; <code>|</code> token.
	 */
	public final function newBOr():IToken
	{
		return newToken(Operators.B_OR);
	}
	
	/**
	 * Returns <code>Operators.B_XOR</code>; <code>^</code> token.
	 */
	public final function newBXor():IToken
	{
		return newToken(Operators.B_XOR);
	}
	
	/**
	 * Returns <code>Operators.COLUMN</code>; <code>:</code> token.
	 */
	public final function newColumn():IToken
	{
		return newToken(Operators.COLUMN);
	}
	
	/**
	 * Returns <code>Operators.COMMA</code>; <code>,</code> token.
	 */
	public final function newComma():IToken
	{
		return newToken(Operators.COMMA);
	}
	
	/**
	 * Returns <code>Operators.DECREMENT</code>; <code>--</code> token.
	 */
	public final function newDecrement():IToken
	{
		return newToken(Operators.DECREMENT);
	}
	
	/**
	 * Returns <code>Operators.DIVIDED_EQUAL</code>; <code>/=</code> token.
	 */
	public final function newDividedEqual():IToken
	{
		return newToken(Operators.DIVIDED_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.DOT</code>; <code>.</code> token.
	 */
	public final function newDot():IToken
	{
		return newToken(Operators.DOT);
	}
	
	/**
	 * Returns <code>Operators.DOUBLE_COLUMN</code>; <code>::</code> token.
	 */
	public final function newDoubleColumn():IToken
	{
		return newToken(Operators.DOUBLE_COLUMN);
	}
	
	/**
	 * Returns <code>Operators.DOUBLE_DOT</code>; <code>..</code> token.
	 */
	public final function newDoubleDot():IToken
	{
		return newToken(Operators.DOUBLE_DOT);
	}
	
	/**
	 * Returns <code>Operators.DOUBLE_EQUAL</code>; <code>==</code> token.
	 */
	public final function newDoubleEqual():IToken
	{
		return newToken(Operators.DOUBLE_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.DOUBLE_QUOTE</code>; <code>"</code> token.
	 */
	public final function newDoubleQuote():IToken
	{
		return newToken(Operators.DOUBLE_QUOTE);
	}
	
	/**
	 * Returns <code>Operators.DOUBLE_SHIFT_LEFT</code>; <code><<</code> token.
	 */
	public final function newDoubleShiftLeft():IToken
	{
		return newToken(Operators.DOUBLE_SHIFT_LEFT);
	}
	
	/**
	 * Returns <code>Operators.DOUBLE_SHIFT_RIGHT</code>; <code>>></code> token.
	 */
	public final function newDoubleShiftRight():IToken
	{
		return newToken(Operators.DOUBLE_SHIFT_RIGHT);
	}
	
	/**
	 * Returns <code>Operators.EQUAL</code>; <code>=</code> token.
	 */
	public final function newEqual():IToken
	{
		return newToken(Operators.EQUAL);
	}
	
	/**
	 * Returns <code>Operators.INCREMENT</code>; <code>++</code> token.
	 */
	public final function newIncrement():IToken
	{
		return newToken(Operators.INCREMENT);
	}
	
	/**
	 * Returns <code>Operators.INFERIOR</code>; <code><</code> token.
	 */
	public final function newInferior():IToken
	{
		return newToken(Operators.INFERIOR);
	}
	
	/**
	 * Returns <code>Operators.INFERIOR_OR_EQUAL</code>; <code><=</code> token.
	 */
	public final function newInferiorOrEqual():IToken
	{
		return newToken(Operators.INFERIOR_OR_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.LEFT_CURLY_BRACKET</code>; <code>{</code> token.
	 */
	public final function newLeftCurlyBracket():IToken
	{
		return newToken(Operators.LEFT_CURLY_BRACKET);
	}
	
	/**
	 * Returns <code>Operators.LEFT_PARENTHESIS</code>; <code>(</code> token.
	 */
	public final function newLeftParenthesis():IToken
	{
		return newToken(Operators.LEFT_PARENTHESIS);
	}
	
	/**
	 * Returns <code>Operators.LEFT_SQUARE_BRACKET</code>; <code>[</code> token.
	 */
	public final function newLeftSquareBracket():IToken
	{
		return newToken(Operators.LEFT_SQUARE_BRACKET);
	}
	
	/**
	 * Returns <code>Operators.LOGICAL_OR</code>; <code>||</code> token.
	 */
	public final function newLogicalOr():IToken
	{
		return newToken(Operators.LOGICAL_OR);
	}
	
	/**
	 * Returns <code>Operators.MINUS</code>; <code>-</code> token.
	 */
	public final function newMinus():IToken
	{
		return newToken(Operators.MINUS);
	}
	
	/**
	 * Returns <code>Operators.MINUS_EQUAL</code>; <code>-=</code> token.
	 */
	public final function newMinusEqual():IToken
	{
		return newToken(Operators.MINUS_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.MODULO</code>; <code>%</code> token.
	 */
	public final function newModulo():IToken
	{
		return newToken(Operators.MODULO);
	}
	
	/**
	 * Returns <code>Operators.MODULO_EQUAL</code>; <code>%=</code> token.
	 */
	public final function newModuloEqual():IToken
	{
		return newToken(Operators.MODULO_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.NON_EQUAL</code>; <code>!=</code> token.
	 */
	public final function newNonEqual():IToken
	{
		return newToken(Operators.NON_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.NON_STRICTLY_EQUAL</code>; <code>!==</code> token.
	 */
	public final function newNonStrictlyEqual():IToken
	{
		return newToken(Operators.NON_STRICTLY_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.OR_EQUAL</code>; <code>|=</code> token.
	 */
	public final function newOrEqual():IToken
	{
		return newToken(Operators.OR_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.PLUS</code>; <code>+</code> token.
	 */
	public final function newPlus():IToken
	{
		return newToken(Operators.PLUS);
	}
	
	/**
	 * Returns <code>Operators.PLUS_EQUAL</code>; <code>+=</code> token.
	 */
	public final function newPlusEqual():IToken
	{
		return newToken(Operators.PLUS_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.QUESTION_MARK</code>; <code>?</code> token.
	 */
	public final function newQuestionMark():IToken
	{
		return newToken(Operators.QUESTION_MARK);
	}
	
	/**
	 * Returns <code>Operators.QUOTE</code>; <code>"</code> token.
	 */
	public final function newQuote():IToken
	{
		return newToken(Operators.QUOTE);
	}
	
	/**
	 * Returns <code>Operators.REST_PARAMETERS</code>; <code>...</code> token.
	 */
	public final function newRestParameters():IToken
	{
		return newToken(Operators.REST_PARAMETERS);
	}
	
	/**
	 * Returns <code>Operators.RIGHT_CURLY_BRACKET</code>; <code>}</code> token.
	 */
	public final function newRightCurlyBracket():IToken
	{
		return newToken(Operators.RIGHT_CURLY_BRACKET);
	}
	
	/**
	 * Returns <code>Operators.RIGHT_PARENTHESIS</code>; <code>)</code> token.
	 */
	public final function newRightParenthesis():IToken
	{
		return newToken(Operators.RIGHT_PARENTHESIS);
	}
	
	/**
	 * Returns <code>Operators.RIGHT_SQUARE_BRACKET</code>; <code>]</code> token.
	 */
	public final function newRightSquareBracket():IToken
	{
		return newToken(Operators.RIGHT_SQUARE_BRACKET);
	}
	
	/**
	 * Returns <code>Operators.SEMI_COLUMN</code>; <code>;</code> token.
	 */
	public final function newSemiColumn():IToken
	{
		return newToken(Operators.SEMI_COLUMN);
	}
	
	/**
	 * Returns <code>Operators.SIMPLE_QUOTE</code>; <code>'</code> token.
	 */
	public final function newSimpleQuote():IToken
	{
		return newToken(Operators.SIMPLE_QUOTE);
	}
	
	/**
	 * Returns <code>Operators.SLASH</code>; <code>/</code> token.
	 */
	public final function newSlash():IToken
	{
		return newToken(Operators.SLASH);
	}
	
	/**
	 * Returns <code>Operators.STRICTLY_EQUAL</code>; <code>===</code> token.
	 */
	public final function newStrictlyEqual():IToken
	{
		return newToken(Operators.STRICTLY_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.SUPERIOR</code>; <code>></code> token.
	 */
	public final function newSuperior():IToken
	{
		return newToken(Operators.SUPERIOR);
	}
	
	/**
	 * Returns <code>Operators.SUPERIOR_OR_EQUAL</code>; <code>>=</code> token.
	 */
	public final function newSuperiorOrEqual():IToken
	{
		return newToken(Operators.SUPERIOR_OR_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.TIMES</code>; <code>*</code> token.
	 */
	public final function newTimes():IToken
	{
		return newToken(Operators.TIMES);
	}
	
	/**
	 * Returns <code>Operators.TIMES</code>; <code>*=</code> token.
	 */
	public final function newTimesEqual():IToken
	{
		return newToken(Operators.TIMES_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.TRIPLE_SHIFT_LEFT</code>; <code><<<</code> token.
	 */
	public final function newTripleLeftShift():IToken
	{
		return newToken(Operators.TRIPLE_SHIFT_LEFT);
	}
	
	/**
	 * Returns <code>Operators.TRIPLE_SHIFT_RIGHT</code>; <code>>>></code> token.
	 */
	public final function newTripleRightShift():IToken
	{
		return newToken(Operators.TRIPLE_SHIFT_RIGHT);
	}
	
	/**
	 * Returns <code>Operators.VECTOR_START</code>; <code>.<</code> token.
	 */
	public final function newVectorStart():IToken
	{
		return newToken(Operators.VECTOR_START);
	}
	
	/**
	 * Returns <code>Operators.XOR_EQUAL</code>; <code>^=</code> token.
	 */
	public final function newXOrEqual():IToken
	{
		return newToken(Operators.XOR_EQUAL);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public Factory :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Returns <code>" "</code> token.
	 */
	public function newSpace():IToken
	{
		return newToken(" ");
	}
	
	/**
	 * Returns <code>\t or "[i]"</code> token.
	 */
	public function newIndent():IToken
	{
		return newToken("\t");
	}
	
	/**
	 * Returns <code>"newIndent()[i]"</code> token.
	 */
	public function newLineIndent():IToken
	{
		var sb:String = "";
		var len:int = indent;
		
		// TODO make this configurable
		for (var i:int = 0; i < len; i++)
		{
			sb += "    "; // newIndent()
		}
		
		return newToken(sb);
	}
	
	/**
	 * Returns <code>\n</code> token.
	 */
	public function newNewLine():IToken
	{
		return newToken("\n");
	}
}
}
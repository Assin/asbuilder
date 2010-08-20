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
	 * Returns a new <code>Token</code>.
	 * 
	 * @param text The String token text.
	 * @return A <code>Token</code> with the token text String.
	 */
	public function newToken(text:String):Token
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
	public final function newAs():Token
	{
		return newToken(KeyWords.AS);
	}
	
	/**
	 * Returns <code>KeyWords.CASE</code> token.
	 */
	public final function newCase():Token
	{
		return newToken(KeyWords.CASE);
	}
	
	/**
	 * Returns <code>KeyWords.CATCH</code> token.
	 */
	public final function newCatch():Token
	{
		return newToken(KeyWords.CATCH);
	}
	
	/**
	 * Returns <code>KeyWords.CLASS</code> token.
	 */
	public final function newClass():Token
	{
		return newToken(KeyWords.CLASS);
	}
	
	/**
	 * Returns <code>KeyWords.CONST</code> token.
	 */
	public final function newConst():Token
	{
		return newToken(KeyWords.CONST);
	}
	
	/**
	 * Returns <code>KeyWords.DEFAULT</code> token.
	 */
	public final function newDefault():Token
	{
		return newToken(KeyWords.DEFAULT);
	}
	
	/**
	 * Returns <code>KeyWords.DELETE</code> token.
	 */
	public final function newDelete():Token
	{
		return newToken(KeyWords.DELETE);
	}
	
	/**
	 * Returns <code>KeyWords.DO</code> token.
	 */
	public final function newDo():Token
	{
		return newToken(KeyWords.DO);
	}
	
	/**
	 * Returns <code>KeyWords.DYNAMIC</code> token.
	 */
	public final function newDynamic():Token
	{
		return newToken(KeyWords.DYNAMIC);
	}
	
	/**
	 * Returns <code>KeyWords.EACH</code> token.
	 */
	public final function newEach():Token
	{
		return newToken(KeyWords.EACH);
	}
	
	/**
	 * Returns <code>KeyWords.ELSE</code> token.
	 */
	public final function newElse():Token
	{
		return newToken(KeyWords.ELSE);
	}
	
	/**
	 * Returns <code>KeyWords.EOF</code> token.
	 */
	public final function newEOF():Token
	{
		return newToken(KeyWords.EOF);
	}
	
	/**
	 * Returns <code>KeyWords.EXTENDS</code> token.
	 */
	public final function newExtends():Token
	{
		return newToken(KeyWords.EXTENDS);
	}
	
	/**
	 * Returns <code>KeyWords.FINAL</code> token.
	 */
	public final function newFinal():Token
	{
		return newToken(KeyWords.FINAL);
	}
	
	/**
	 * Returns <code>KeyWords.FINALLY</code> token.
	 */
	public final function newFinally():Token
	{
		return newToken(KeyWords.FINALLY);
	}
	
	/**
	 * Returns <code>KeyWords.FOR</code> token.
	 */
	public final function newFor():Token
	{
		return newToken(KeyWords.FOR);
	}
	
	/**
	 * Returns <code>KeyWords.FUNCTION</code> token.
	 */
	public final function newFunction():Token
	{
		return newToken(KeyWords.FUNCTION);
	}
	
	/**
	 * Returns <code>KeyWords.GET</code> token.
	 */
	public final function newGet():Token
	{
		return newToken(KeyWords.GET);
	}
	
	/**
	 * Returns <code>KeyWords.IF</code> token.
	 */
	public final function newIf():Token
	{
		return newToken(KeyWords.IF);
	}
	
	/**
	 * Returns <code>KeyWords.IMPLEMENTS</code> token.
	 */
	public final function newImplements():Token
	{
		return newToken(KeyWords.IMPLEMENTS);
	}
	
	/**
	 * Returns <code>KeyWords.IMPORT</code> token.
	 */
	public final function newImport():Token
	{
		return newToken(KeyWords.IMPORT);
	}
	
	/**
	 * Returns <code>KeyWords.IN</code> token.
	 */
	public final function newIn():Token
	{
		return newToken(KeyWords.IN);
	}
	
	/**
	 * Returns <code>KeyWords.INCLUDE</code> token.
	 */
	public final function newInclude():Token
	{
		return newToken(KeyWords.INCLUDE);
	}
	
	/**
	 * Returns <code>KeyWords.INSTANCE_OF</code> token.
	 */
	public final function newInstanceOf():Token
	{
		return newToken(KeyWords.INSTANCE_OF);
	}
	
	/**
	 * Returns <code>KeyWords.INTERFACE</code> token.
	 */
	public final function newInterface():Token
	{
		return newToken(KeyWords.INTERFACE);
	}
	
	/**
	 * Returns <code>KeyWords.INTERNAL</code> token.
	 */
	public final function newInternal():Token
	{
		return newToken(KeyWords.INTERNAL);
	}
	
	/**
	 * Returns <code>KeyWords.IS</code> token.
	 */
	public final function newIs():Token
	{
		return newToken(KeyWords.IS);
	}
	
	/**
	 * Returns <code>KeyWords.NAMESPACE</code> token.
	 */
	public final function newNamespace():Token
	{
		return newToken(KeyWords.NAMESPACE);
	}
	
	/**
	 * Returns <code>KeyWords.NEW</code> token.
	 */
	public final function newNew():Token
	{
		return newToken(KeyWords.NEW);
	}
	
	/**
	 * Returns <code>KeyWords.OVERRIDE</code> token.
	 */
	public final function newOverride():Token
	{
		return newToken(KeyWords.OVERRIDE);
	}
	
	/**
	 * Returns <code>KeyWords.PACKAGE</code> token.
	 */
	public final function newPackage():Token
	{
		return newToken(KeyWords.PACKAGE);
	}
	
	/**
	 * Returns <code>KeyWords.PRIVATE</code> token.
	 */
	public final function newPrivate():Token
	{
		return newToken(KeyWords.PRIVATE);
	}
	
	/**
	 * Returns <code>KeyWords.PROTECTED</code> token.
	 */
	public final function newProtected():Token
	{
		return newToken(KeyWords.PROTECTED);
	}
	
	/**
	 * Returns <code>KeyWords.public final</code> token.
	 */
	public final function newPublic():Token
	{
		return newToken(KeyWords.PUBLIC);
	}
	
	/**
	 * Returns <code>KeyWords.RETURN</code> token.
	 */
	public final function newReturn():Token
	{
		return newToken(KeyWords.RETURN);
	}
	
	/**
	 * Returns <code>KeyWords.SET</code> token.
	 */
	public final function newSet():Token
	{
		return newToken(KeyWords.SET);
	}
	
	/**
	 * Returns <code>KeyWords.STATIC</code> token.
	 */
	public final function newStatic():Token
	{
		return newToken(KeyWords.STATIC);
	}
	
	/**
	 * Returns <code>KeyWords.SUPER</code> token.
	 */
	public final function newSuper():Token
	{
		return newToken(KeyWords.SUPER);
	}
	
	/**
	 * Returns <code>KeyWords.SWITCH</code> token.
	 */
	public final function newSwitch():Token
	{
		return newToken(KeyWords.SWITCH);
	}
	
	/**
	 * Returns <code>KeyWords.TRY</code> token.
	 */
	public final function newTry():Token
	{
		return newToken(KeyWords.TRY);
	}
	
	/**
	 * Returns <code>KeyWords.TYPEOF</code> token.
	 */
	public final function newTypeof():Token
	{
		return newToken(KeyWords.TYPEOF);
	}
	
	/**
	 * Returns <code>KeyWords.USE</code> token.
	 */
	public final function newUse():Token
	{
		return newToken(KeyWords.USE);
	}
	
	/**
	 * Returns <code>KeyWords.VAR</code> token.
	 */
	public final function newVar():Token
	{
		return newToken(KeyWords.VAR);
	}
	
	/**
	 * Returns <code>KeyWords.VOID</code> token.
	 */
	public final function newVoid():Token
	{
		return newToken(KeyWords.VOID);
	}
	
	/**
	 * Returns <code>KeyWords.WHILE</code> token.
	 */
	public final function newWhile():Token
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
	public final function newAnd():Token
	{
		return newToken(Operators.AND);
	}
	
	/**
	 * Returns <code>Operators.AND_EQUAL</code>; <code>&=</code> token.
	 */
	public final function newAndEqual():Token
	{
		return newToken(Operators.AND_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.AT</code>; <code>@</code> token.
	 */
	public final function newAt():Token
	{
		return newToken(Operators.AT);
	}
	
	/**
	 * Returns <code>Operators.B_AND</code>; <code>&</code> token.
	 */
	public final function newBAnd():Token
	{
		return newToken(Operators.B_AND);
	}
	
	/**
	 * Returns <code>Operators.B_OR</code>; <code>|</code> token.
	 */
	public final function newBOr():Token
	{
		return newToken(Operators.B_OR);
	}
	
	/**
	 * Returns <code>Operators.B_XOR</code>; <code>^</code> token.
	 */
	public final function newBXor():Token
	{
		return newToken(Operators.B_XOR);
	}
	
	/**
	 * Returns <code>Operators.COLUMN</code>; <code>:</code> token.
	 */
	public final function newColumn():Token
	{
		return newToken(Operators.COLUMN);
	}
	
	/**
	 * Returns <code>Operators.COMMA</code>; <code>,</code> token.
	 */
	public final function newComma():Token
	{
		return newToken(Operators.COMMA);
	}
	
	/**
	 * Returns <code>Operators.DECREMENT</code>; <code>--</code> token.
	 */
	public final function newDecrement():Token
	{
		return newToken(Operators.DECREMENT);
	}
	
	/**
	 * Returns <code>Operators.DIVIDED_EQUAL</code>; <code>/=</code> token.
	 */
	public final function newDividedEqual():Token
	{
		return newToken(Operators.DIVIDED_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.DOT</code>; <code>.</code> token.
	 */
	public final function newDot():Token
	{
		return newToken(Operators.DOT);
	}
	
	/**
	 * Returns <code>Operators.DOUBLE_COLUMN</code>; <code>::</code> token.
	 */
	public final function newDoubleColumn():Token
	{
		return newToken(Operators.DOUBLE_COLUMN);
	}
	
	/**
	 * Returns <code>Operators.DOUBLE_DOT</code>; <code>..</code> token.
	 */
	public final function newDoubleDot():Token
	{
		return newToken(Operators.DOUBLE_DOT);
	}
	
	/**
	 * Returns <code>Operators.DOUBLE_EQUAL</code>; <code>==</code> token.
	 */
	public final function newDoubleEqual():Token
	{
		return newToken(Operators.DOUBLE_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.DOUBLE_QUOTE</code>; <code>"</code> token.
	 */
	public final function newDoubleQuote():Token
	{
		return newToken(Operators.DOUBLE_QUOTE);
	}
	
	/**
	 * Returns <code>Operators.DOUBLE_SHIFT_LEFT</code>; <code><<</code> token.
	 */
	public final function newDoubleShiftLeft():Token
	{
		return newToken(Operators.DOUBLE_SHIFT_LEFT);
	}
	
	/**
	 * Returns <code>Operators.DOUBLE_SHIFT_RIGHT</code>; <code>>></code> token.
	 */
	public final function newDoubleShiftRight():Token
	{
		return newToken(Operators.DOUBLE_SHIFT_RIGHT);
	}
	
	/**
	 * Returns <code>Operators.EQUAL</code>; <code>=</code> token.
	 */
	public final function newEqual():Token
	{
		return newToken(Operators.EQUAL);
	}
	
	/**
	 * Returns <code>Operators.INCREMENT</code>; <code>++</code> token.
	 */
	public final function newIncrement():Token
	{
		return newToken(Operators.INCREMENT);
	}
	
	/**
	 * Returns <code>Operators.INFERIOR</code>; <code><</code> token.
	 */
	public final function newInferior():Token
	{
		return newToken(Operators.INFERIOR);
	}
	
	/**
	 * Returns <code>Operators.INFERIOR_OR_EQUAL</code>; <code><=</code> token.
	 */
	public final function newInferiorOrEqual():Token
	{
		return newToken(Operators.INFERIOR_OR_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.LEFT_CURLY_BRACKET</code>; <code>{</code> token.
	 */
	public final function newLeftCurlyBracket():Token
	{
		return newToken(Operators.LEFT_CURLY_BRACKET);
	}
	
	/**
	 * Returns <code>Operators.LEFT_PARENTHESIS</code>; <code>(</code> token.
	 */
	public final function newLeftParenthesis():Token
	{
		return newToken(Operators.LEFT_PARENTHESIS);
	}
	
	/**
	 * Returns <code>Operators.LEFT_SQUARE_BRACKET</code>; <code>[</code> token.
	 */
	public final function newLeftSquareBracket():Token
	{
		return newToken(Operators.LEFT_SQUARE_BRACKET);
	}
	
	/**
	 * Returns <code>Operators.LOGICAL_OR</code>; <code>||</code> token.
	 */
	public final function newLogicalOr():Token
	{
		return newToken(Operators.LOGICAL_OR);
	}
	
	/**
	 * Returns <code>Operators.MINUS</code>; <code>-</code> token.
	 */
	public final function newMinus():Token
	{
		return newToken(Operators.MINUS);
	}
	
	/**
	 * Returns <code>Operators.MINUS_EQUAL</code>; <code>-=</code> token.
	 */
	public final function newMinusEqual():Token
	{
		return newToken(Operators.MINUS_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.MODULO</code>; <code>%</code> token.
	 */
	public final function newModulo():Token
	{
		return newToken(Operators.MODULO);
	}
	
	/**
	 * Returns <code>Operators.MODULO_EQUAL</code>; <code>%=</code> token.
	 */
	public final function newModuloEqual():Token
	{
		return newToken(Operators.MODULO_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.NON_EQUAL</code>; <code>!=</code> token.
	 */
	public final function newNonEqual():Token
	{
		return newToken(Operators.NON_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.NON_STRICTLY_EQUAL</code>; <code>!==</code> token.
	 */
	public final function newNonStrictlyEqual():Token
	{
		return newToken(Operators.NON_STRICTLY_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.OR_EQUAL</code>; <code>|=</code> token.
	 */
	public final function newOrEqual():Token
	{
		return newToken(Operators.OR_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.PLUS</code>; <code>+</code> token.
	 */
	public final function newPlus():Token
	{
		return newToken(Operators.PLUS);
	}
	
	/**
	 * Returns <code>Operators.PLUS_EQUAL</code>; <code>+=</code> token.
	 */
	public final function newPlusEqual():Token
	{
		return newToken(Operators.PLUS_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.QUESTION_MARK</code>; <code>?</code> token.
	 */
	public final function newQuestionMark():Token
	{
		return newToken(Operators.QUESTION_MARK);
	}
	
	/**
	 * Returns <code>Operators.QUOTE</code>; <code>"</code> token.
	 */
	public final function newQuote():Token
	{
		return newToken(Operators.QUOTE);
	}
	
	/**
	 * Returns <code>Operators.REST_PARAMETERS</code>; <code>...</code> token.
	 */
	public final function newRestParameters():Token
	{
		return newToken(Operators.REST_PARAMETERS);
	}
	
	/**
	 * Returns <code>Operators.RIGHT_CURLY_BRACKET</code>; <code>}</code> token.
	 */
	public final function newRightCurlyBracket():Token
	{
		return newToken(Operators.RIGHT_CURLY_BRACKET);
	}
	
	/**
	 * Returns <code>Operators.RIGHT_PARENTHESIS</code>; <code>)</code> token.
	 */
	public final function newRightParenthesis():Token
	{
		return newToken(Operators.RIGHT_PARENTHESIS);
	}
	
	/**
	 * Returns <code>Operators.RIGHT_SQUARE_BRACKET</code>; <code>]</code> token.
	 */
	public final function newRightSquareBracket():Token
	{
		return newToken(Operators.RIGHT_SQUARE_BRACKET);
	}
	
	/**
	 * Returns <code>Operators.SEMI_COLUMN</code>; <code>;</code> token.
	 */
	public final function newSemiColumn():Token
	{
		return newToken(Operators.SEMI_COLUMN);
	}
	
	/**
	 * Returns <code>Operators.SIMPLE_QUOTE</code>; <code>'</code> token.
	 */
	public final function newSimpleQuote():Token
	{
		return newToken(Operators.SIMPLE_QUOTE);
	}
	
	/**
	 * Returns <code>Operators.SLASH</code>; <code>/</code> token.
	 */
	public final function newSlash():Token
	{
		return newToken(Operators.SLASH);
	}
	
	/**
	 * Returns <code>Operators.STRICTLY_EQUAL</code>; <code>===</code> token.
	 */
	public final function newStrictlyEqual():Token
	{
		return newToken(Operators.STRICTLY_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.SUPERIOR</code>; <code>></code> token.
	 */
	public final function newSuperior():Token
	{
		return newToken(Operators.SUPERIOR);
	}
	
	/**
	 * Returns <code>Operators.SUPERIOR_OR_EQUAL</code>; <code>>=</code> token.
	 */
	public final function newSuperiorOrEqual():Token
	{
		return newToken(Operators.SUPERIOR_OR_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.TIMES</code>; <code>*</code> token.
	 */
	public final function newTimes():Token
	{
		return newToken(Operators.TIMES);
	}
	
	/**
	 * Returns <code>Operators.TIMES</code>; <code>*=</code> token.
	 */
	public final function newTimesEqual():Token
	{
		return newToken(Operators.TIMES_EQUAL);
	}
	
	/**
	 * Returns <code>Operators.TRIPLE_SHIFT_LEFT</code>; <code><<<</code> token.
	 */
	public final function newTripleLeftShift():Token
	{
		return newToken(Operators.TRIPLE_SHIFT_LEFT);
	}
	
	/**
	 * Returns <code>Operators.TRIPLE_SHIFT_RIGHT</code>; <code>>>></code> token.
	 */
	public final function newTripleRightShift():Token
	{
		return newToken(Operators.TRIPLE_SHIFT_RIGHT);
	}
	
	/**
	 * Returns <code>Operators.VECTOR_START</code>; <code>.<</code> token.
	 */
	public final function newVectorStart():Token
	{
		return newToken(Operators.VECTOR_START);
	}
	
	/**
	 * Returns <code>Operators.XOR_EQUAL</code>; <code>^=</code> token.
	 */
	public final function newXOrEqual():Token
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
	public function newSpace():Token
	{
		return newToken(" ");
	}
	
	/**
	 * Returns <code>\t or "[i]"</code> token.
	 */
	public function newIndent():Token
	{
		return newToken("\t");
	}
	
	/**
	 * Returns <code>"newIndent()[i]"</code> token.
	 */
	public function newLineIndent():Token
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
	public function newNewLine():Token
	{
		return newToken("\n");
	}
}
}
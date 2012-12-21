PassthroughFormatter = require './helpers/passthrough_formatter'
{buildField} = require './helpers/builders'
{expectThatTyping} = require './helpers/expectations'

describe 'FormattedTextField', ->
  describe 'typing a character into an empty field', ->
    it 'allows the character to be inserted', ->
      expectThatTyping('a').willChange('|').to('a|')

  describe 'typing a character into a full field', ->
    formatter = null

    beforeEach ->
      formatter = new PassthroughFormatter()
      formatter.length = 2

    it 'does not allow the character to be inserted', ->
      expectThatTyping('0').withFormatter(formatter).willNotChange('12|')

    describe 'with part of the value selected', ->
      it 'replaces the selection with the typed character', ->
        expectThatTyping('0').withFormatter(formatter).willChange('|1|2').to('0|2')

  describe 'typing a backspace', ->
    describe 'with a non-empty selection', ->
      it 'clears the selection', ->
        expectThatTyping('backspace').willChange('12|34|5').to('12|5')
        expectThatTyping('backspace').willChange('12<34|5').to('12|5')
        expectThatTyping('backspace').willChange('12|34>5').to('12|5')

        expectThatTyping('alt+backspace').willChange('12|3 4|5').to('12|5')
        expectThatTyping('alt+backspace').willChange('12<3 4|5').to('12|5')
        expectThatTyping('alt+backspace').willChange('12|3 4>5').to('12|5')

        expectThatTyping('meta+backspace').willChange('12|3 4>5').to('12|5')

    describe 'with an empty selection', ->
      it 'works as expected', ->
        expectThatTyping('backspace').willNotChange('|12')
        expectThatTyping('backspace').willChange('1|2').to('|2')

        expectThatTyping('alt+backspace').willNotChange('|12')
        expectThatTyping('alt+backspace').willChange('12|').to('|')
        expectThatTyping('alt+backspace').willChange('12 34|').to('12 |')
        expectThatTyping('alt+backspace').willChange('12 |34').to('|34')

        expectThatTyping('meta+backspace').willChange('12 34 |56').to('|56')

  describe 'typing forward delete', ->
    describe 'with a non-empty selection', ->
      it 'clears the selection', ->
        expectThatTyping('delete').willChange('12|34|5').to('12|5')
        expectThatTyping('delete').willChange('12<34|5').to('12|5')
        expectThatTyping('delete').willChange('12|34>5').to('12|5')

        expectThatTyping('alt+delete').willChange('12|3 4|5').to('12|5')
        expectThatTyping('alt+delete').willChange('12<3 4|5').to('12|5')
        expectThatTyping('alt+delete').willChange('12|3 4>5').to('12|5')

    describe 'with an empty selection', ->
      it 'works as expected', ->
        expectThatTyping('delete').willNotChange('12|')
        expectThatTyping('delete').willChange('1|2').to('1|')

        expectThatTyping('alt+delete').willNotChange('12|')
        expectThatTyping('alt+delete').willChange('|12').to('|')
        expectThatTyping('alt+delete').willChange('|12 34').to('| 34')
        expectThatTyping('alt+delete').willChange('12| 34').to('12|')

  describe 'typing a left arrow', ->
    it 'works as expected', ->
      expectThatTyping('left').willNotChange('|4111')
      expectThatTyping('left').willChange('4|111').to('|4111')
      expectThatTyping('left').willChange('41|1|1').to('41|11')

      expectThatTyping('shift+left').willNotChange('<41|11')
      expectThatTyping('shift+left').willChange('4<1|11').to('<41|11')
      expectThatTyping('shift+left').willChange('|41>11').to('|4>111')
      expectThatTyping('shift+left').willChange('|4111 1>111').to('|4111 >1111')
      expectThatTyping('shift+left', 'shift+left').willChange('41|1>1').to('4<1|11')

      expectThatTyping('alt+left').willChange('41|11').to('|4111')
      expectThatTyping('alt+left').willChange('4111 11|11').to('4111 |1111')
      expectThatTyping('alt+left', 'alt+left').willChange('4111 11|11').to('|4111 1111')

      expectThatTyping('shift+alt+left').willChange('41|11').to('<41|11')
      expectThatTyping('shift+alt+left').willChange('4111 11|11').to('4111 <11|11')
      expectThatTyping('shift+alt+left', 'shift+alt+left').willChange('4111 11|11').to('<4111 11|11')

      expectThatTyping('meta+left').willChange('41|11').to('|4111')
      expectThatTyping('shift+meta+left').willChange('41|11').to('<41|11')
      expectThatTyping('shift+meta+left').willNotChange('|4111')

  describe 'typing a right arrow', ->
    it 'works as expected', ->
      expectThatTyping('right').willChange('|4111').to('4|111')
      expectThatTyping('right').willNotChange('4111|')
      expectThatTyping('right').willChange('41|1|1').to('411|1')

      expectThatTyping('shift+right').willNotChange('41|11>')
      expectThatTyping('shift+right').willChange('<41|11').to('4<1|11')
      expectThatTyping('shift+right').willChange('|41>11').to('|411>1')
      expectThatTyping('shift+right').willChange('|4111> 1111').to('|4111 >1111')
      expectThatTyping('shift+right', 'shift+right').willChange('41<1|1').to('411|1>')

      expectThatTyping('alt+right').willChange('41|11').to('4111|')
      expectThatTyping('alt+right').willChange('41|11 1111').to('4111| 1111')
      expectThatTyping('alt+right', 'alt+right').willChange('41|11 1111').to('4111 1111|')

      expectThatTyping('shift+alt+right').willChange('41|11').to('41|11>')
      expectThatTyping('shift+alt+right').willChange('41|11 1111').to('41|11> 1111')
      expectThatTyping('shift+alt+right', 'shift+alt+right').willChange('41|11 1111').to('41|11 1111>')

      expectThatTyping('meta+right').willChange('41|11').to('4111|')
      expectThatTyping('shift+meta+right').willChange('41|11').to('41|11>')
      expectThatTyping('shift+meta+right').willNotChange('4111|')

  describe 'typing an up arrow', ->
    it 'works as expected', ->
      expectThatTyping('up').willChange('4111|').to('|4111')
      expectThatTyping('up').willChange('411|1').to('|4111')
      expectThatTyping('up').willChange('41|1|1').to('|4111')
      expectThatTyping('up').willChange('41|1>1').to('|4111')
      expectThatTyping('up').willChange('41<1|1').to('|4111')

      expectThatTyping('shift+up').willChange('41|11>').to('<41|11')
      expectThatTyping('shift+up').willNotChange('<41|11')
      expectThatTyping('shift+up').willChange('|41>11').to('|4111')
      expectThatTyping('shift+up').willChange('|4111> 1111').to('|4111 1111')
      expectThatTyping('shift+up').willChange('41<1|1').to('<411|1')

      expectThatTyping('alt+up').willChange('41|11').to('|4111')
      expectThatTyping('alt+up').willChange('41|11 1111').to('|4111 1111')

      expectThatTyping('shift+alt+up').willChange('41|11').to('<41|11')
      expectThatTyping('shift+alt+up').willChange('4111 11|11').to('<4111 11|11')
      expectThatTyping('shift+alt+up', 'shift+alt+up').willChange('4111 11|11').to('<4111 11|11')
      expectThatTyping('shift+alt+up').willChange('4111 |11>11').to('4111 |1111')

      expectThatTyping('meta+up').willChange('41|11').to('|4111')
      expectThatTyping('shift+meta+up').willChange('41|1>1').to('<411|1')
      expectThatTyping('shift+meta+up').willChange('41|11').to('<41|11')

  describe 'typing a down arrow', ->
    it 'works as expected', ->
      expectThatTyping('down').willChange('|4111').to('4111|')
      expectThatTyping('down').willChange('411|1').to('4111|')
      expectThatTyping('down').willChange('41|1|1').to('4111|')
      expectThatTyping('down').willChange('41|1>1').to('4111|')
      expectThatTyping('down').willChange('41<1|1').to('4111|')

      expectThatTyping('shift+down').willNotChange('41|11>')
      expectThatTyping('shift+down').willChange('<41|11').to('41|11>')
      expectThatTyping('shift+down').willChange('41<11|').to('4111|')
      expectThatTyping('shift+down').willChange('|4111> 1111').to('|4111 1111>')
      expectThatTyping('shift+down').willChange('41|1>1').to('41|11>')

      expectThatTyping('alt+down').willChange('41|11').to('4111|')
      expectThatTyping('alt+down').willChange('41|11 1111').to('4111 1111|')

      expectThatTyping('shift+alt+down').willChange('41|11').to('41|11>')
      expectThatTyping('shift+alt+down').willChange('41|11 1111').to('41|11 1111>')
      expectThatTyping('shift+alt+down').willChange('<41|11 1111').to('41|11 1111')
      expectThatTyping('shift+alt+down', 'shift+alt+down').willChange('4111| 1111').to('4111| 1111>')

      expectThatTyping('meta+down').willChange('41|11').to('4111|')
      expectThatTyping('shift+meta+down').willChange('4<1|11').to('4|111>')
      expectThatTyping('shift+meta+down').willChange('41|11').to('41|11>')

  describe 'selecting everything', ->
    ['ctrl', 'meta'].forEach (modifier) ->
      describe "with the #{modifier} key", ->
      it 'works without an existing selection', ->
        expectThatTyping("#{modifier}+a").willChange('123|4567').to('|1234567|')

      it 'works with an undirected selection', ->
        expectThatTyping("#{modifier}+a").willChange('|123|4567').to('|1234567|')

      it 'works with a right-directed selection and resets the direction', ->
        expectThatTyping("#{modifier}+a").willChange('|123>4567').to('|1234567|')

      it 'works with a left-directed selection and resets the direction', ->
        expectThatTyping("#{modifier}+a").willChange('<123|4567').to('|1234567|')

  it 'allows the formatter to prevent changes', ->
    field = buildField()
    field.formatter.isChangeValid = -> no
    expectThatTyping('backspace').into(field).willNotChange('3725 |')
    expectThatTyping('a').into(field).willNotChange('3725 |')

  it 'allows the formatter to alter caret changes', ->
    field = buildField()
    # disallow the caret at the start of text
    field.formatter.isChangeValid = (change) ->
      if change.proposed.caret.start is 0 and change.proposed.caret.end is 0
        change.proposed.caret = start: 1, end: 1
      return yes

    expectThatTyping('up').into(field).willChange(' 234|').to(' |234')

    # disallow selection
    field.formatter.isChangeValid = (change) ->
      caret = change.proposed.caret
      if caret.start isnt caret.end
        if change.field.selectionAnchor is caret.start
          caret.start = caret.end
        else
          caret.end = caret.start
      return yes

    expectThatTyping('shift+left').into(field).willChange('234|').to('23|4')
    expectThatTyping('shift+up').into(field).willChange('234|').to('|234')
    expectThatTyping('shift+right').into(field).willChange('2|34').to('23|4')
    expectThatTyping('shift+down').into(field).willChange('2|34').to('234|')
    expectThatTyping('meta+a').into(field).willNotChange('|1234')
    expectThatTyping('alt+shift+right').into(field).willChange('|12 34').to('12| 34')

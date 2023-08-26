import describe, it, expect from require('lib.lust').nocolor!
import unpack_keys_to from require 'help.table'

describe('help.table', ->
	describe('unpack_keys_to', ->
		it("copies all keys from one table to another", ->
			source = { b: 20, c: 30, d: { inner_a: 10 } }
			target = { a: 10 }
			keys = { 'b', 'c', 'd' }
			result = { a: 10, b: 20, c: 30, d: { inner_a: 10 } }

			unpack_keys_to(source, target, keys)

			expect(target.a).to.exist!
			expect(target.b).to.exist!
			expect(target.c).to.exist!
			expect(target.d).to.exist!
			expect(target.d.inner_a).to.exist!
			expect(target).to.equal(result)
		)

		it("doesn't copy keys that weren't given", ->
			source = { a: 10, b: 20, c: 30 }
			target = { d: 40 }
			keys = { 'b' }

			unpack_keys_to(source, target, keys)

			expect(target.a).to_not.exist!
			expect(target.b).to.exist!
		)

		it("leaves the rest of the table alone", ->
			source = { a: 10, b: 20, c: 30 }
			target = { d: 40 }
			keys = { 'b' }

			unpack_keys_to(source, target, keys)

			expect(target.d).to.exist!
			expect(target.d).to.be(40)
		)

		it("doesn't work with missing keys", ->
			expect(-> unpack_keys_to({}, {})).to.fail!
		)
	)
)

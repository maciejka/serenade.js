require './../spec_helper'

describe 'Collection', ->
  beforeEach ->
    @setupDom()

  it 'compiles a collection instruction', ->
    model = { people: [{ name: 'jonas' }, { name: 'peter' }] }

    @render '''
      ul
        - collection @people
          li[id=name]
    ''', model
    expect(@body).to.have.element('ul > li#jonas')
    expect(@body).to.have.element('ul > li#peter')

  it 'can reference the items itself', ->
    model = { people: ['jonas', 'peter'] }

    @render '''
      ul
        - collection @people
          li[id=@ style:color=@] @
    ''', model
    expect(@body).to.have.element('ul > li#jonas')
    expect(@body).to.have.element('ul > li#peter')
    expect(@body.querySelector("#jonas")).to.have.text("jonas")
    expect(@body.querySelector("#peter")).to.have.text("peter")
    expect(@body.querySelector("li").style.color).to.eql("jonas")

  it 'compiles a Serenade.collection in a collection instruction', ->
    model = { people: new Serenade.Collection([{ name: 'jonas' }, { name: 'peter' }]) }

    @render '''
      ul
        - collection @people
          li[id=name]
    ''', model
    expect(@body).to.have.element('ul > li#jonas')
    expect(@body).to.have.element('ul > li#peter')

  it 'updates a collection dynamically', ->
    model = { people: new Serenade.Collection([{ name: 'jonas' }, { name: 'peter' }]) }

    @render '''
      ul
        - collection @people
          li[id=name]
    ''', model
    expect(@body).to.have.element('ul > li#jonas')
    expect(@body).to.have.element('ul > li#peter')
    model.people.update([{ name: 'anders' }, { name: 'jimmy' }])
    expect(@body).not.to.have.element('ul > li#jonas')
    expect(@body).not.to.have.element('ul > li#peter')
    expect(@body).to.have.element('ul > li#anders')
    expect(@body).to.have.element('ul > li#jimmy')

  it 'removes item from collection when requested', ->
    model = { people: new Serenade.Collection([{ name: 'jonas' }, { name: 'peter' }]) }

    @render '''
      ul
        - collection @people
          li[id=name]
    ''', model
    expect(@body).to.have.element('ul > li#jonas')
    expect(@body).to.have.element('ul > li#peter')
    model.people.deleteAt(0)
    expect(@body).not.to.have.element('ul > li#jonas')
    expect(@body).to.have.element('ul > li#peter')

  it 'inserts item into collection when requested', ->
    model = { people: new Serenade.Collection([{ name: 'jonas' }, { name: 'peter' }]) }

    @render '''
      ul
        - collection @people
          li[id=name]
    ''', model
    expect(@body).to.have.element('ul > li#jonas')
    expect(@body).to.have.element('ul > li#peter')
    model.people.insertAt(1, {name: "carry"})
    expect(@body).to.have.element('ul > li#jonas')
    expect(@body).to.have.element('ul > li#carry')
    expect(@body).to.have.element('ul > li#peter')

  it 'can insert at index zero', ->
    model = { people: new Serenade.Collection([]) }

    @render '''
      ul
        - collection @people
          li[id=name]
    ''', model
    model.people.insertAt(0, {name: "carry"})
    expect(@body).to.have.element('ul > li#carry')

  it 'updates when the collection is replaced', ->
    model = Serenade(things: ["hello"])

    @render """
      ul
        - collection @things
          li[id=@]
    """, model
    model.things = ["world"]
    expect(@body).to.have.element('ul > li#world')

  it 'can handle being a root node', ->
    model = Serenade(things: ["hello"])

    @render """
      - collection @things
        @
    """, model
    expect(@body).to.have.text("hello")
    model.things = []
    expect(@body).to.have.text("")
    model.things = ["foo", "bar"]
    expect(@body).to.have.text("foobar")

  it 'passes collection item into controller', ->
    model = { things: [{ name: "foo" }, { name: "baz" }, {name: "bar"}] }
    controller = { mark: (_, item) -> item.marked = true }

    @render """
      ul
        - collection @things
          li[event:click=mark id=@name]
    """, model, controller
    @fireEvent @body.querySelector('#baz'), 'click'
    expect(model.things[1].marked).to.be.ok

  it 'can render same collection multiple times', ->
    model = { people: new Serenade.Collection(["jonas"]) }

    @render '''
      ul#one
        - collection @people
          li.one[class=@]
      ul#two
        - collection @people
          li.two[class=@]
      ul#three
        - collection @people
          li.three[class=@]
    ''', model
    model.people.push("peter")
    model.people.push("kim")
    expect(@body).to.have.element('#one > .jonas')
    expect(@body).to.have.element('#one > .kim')
    expect(@body).to.have.element('#one > .peter')
    expect(@body).to.have.element('#two > .jonas')
    expect(@body).to.have.element('#two > .kim')
    expect(@body).to.have.element('#one > .peter')
    expect(@body).to.have.element('#three > .jonas')
    expect(@body).to.have.element('#three > .kim')
    model.people.delete("peter")
    expect(@body).to.have.element('#one > .jonas')
    expect(@body).to.have.element('#one > .kim')
    expect(@body).not.to.have.element('#one > .peter')
    expect(@body).to.have.element('#two > .jonas')
    expect(@body).to.have.element('#two > .kim')
    expect(@body).not.to.have.element('#one > .peter')
    expect(@body).to.have.element('#three > .jonas')
    expect(@body).to.have.element('#three > .kim')
    expect(@body.querySelector('#one').children.length).to.eql(2)
    expect(@body.querySelector('#two').children.length).to.eql(2)
    expect(@body.querySelector('#three').children.length).to.eql(2)

{Serenade} = require '../src/serenade'

describe 'Serenade.Model', ->
  afterEach ->
    Serenade.Model._identityMap = {}
    Serenade.Model._all = undefined

  describe '#constructor', ->
    it 'sets the given properties', ->
      john = new Serenade.Model(name: 'John', age: 23)
      expect(john.get('age')).toEqual(23)
      expect(john.get('name')).toEqual('John')

    it 'returns the same object if given the same id', ->
      john1 = new Serenade.Model(id: 'j123', name: 'John', age: 23)
      john1.test = true
      john2 = new Serenade.Model(id: 'j123', age: 46)

      expect(john2.test).toBeTruthy()
      expect(john2.get('age')).toEqual(46)
      expect(john2.get('name')).toEqual('John')

    it 'returns a new object when given a different id', ->
      john1 = new Serenade.Model(id: 'j123', name: 'John', age: 23)
      john1.test = true
      john2 = new Serenade.Model(id: 'j456', age: 46)

      expect(john2.test).toBeFalsy()
      expect(john2.get('age')).toEqual(46)
      expect(john2.get('name')).toBeUndefined()

  describe '.find', ->
    it 'creates a new blank object with the given id', ->
      document = Serenade.Model.find('j123')
      expect(document.get('id')).toEqual('j123')
    it 'returns the same object if it has previously been initialized', ->
      john1 = new Serenade.Model(id: 'j123', name: 'John')
      john1.test = true
      john2 = Serenade.Model.find('j123')
      expect(john2.test).toBeTruthy()
      expect(john2.get('name')).toEqual('John')

  describe '.belongsTo', ->
    it 'uses the given constructor', ->
      class Comment extends Serenade.Model
        @property 'body'
      class Post extends Serenade.Model
        @belongsTo('comment', Comment)
      post = new Post(comment: { body: 'Hello' })
      expect(post.comment.constructor).toEqual(Comment)
      expect(post.comment.body).toEqual('Hello')
    it 'creates a plain object if there is no constructor given', ->
      class Post extends Serenade.Model
        @belongsTo('comment')
      post = new Post(comment: { body: 'Hello' })
      expect(post.comment.constructor).toEqual(Object)
      expect(post.comment.body).toEqual('Hello')
    it 'updates the id property as it changes', ->
      class Post extends Serenade.Model
        @belongsTo('comment')
      post = new Post(comment: { id: 5, body: 'Hello' })
      expect(post.commentId).toEqual(5)
      post.comment = id: 12
      expect(post.commentId).toEqual(12)
    #it 'is updated if the id property changes', ->
    #  class Comment extends Serenade.Model
    #    @property 'body'
    #  class Post extends Serenade.Model
    #    @belongsTo('comment', Comment)
    #  comment1 = new Comment(id: 5, body: 'Hello')
    #  comment2 = new Comment(id: 12, body: 'World')
    #  post = new Post(commentId: 5)
    #  expect(post.comment.body).toEqual('Hello')
    #  post.commentId = 12
    #  expect(post.comment.body).toEqual('World')

  describe '.hasMany', ->
    it 'uses the given constructor', ->
    it 'uses the constructor given as a string', ->
    it 'creates plain objects if there is no constructor given', ->
    it 'updates the ids property as it changes', ->
    it 'is updated if the ids property changes', ->

  describe '.property', ->
    context 'with serialize with a string given', ->
      it 'will setup a setter method for that name', ->

  describe '#serialize()', ->
    it 'serializes only the id by default', ->
    it 'serializes any properties marked as serializable', ->
    it 'serializes properties with the given string as key', ->
    it 'serializes a property with the given function', ->
    it 'serializes a belongs to association', ->
    it 'serializes a has many association', ->
    it 'serializes the id of a belongs to association', ->
    it 'serializes the ids of a has many association', ->
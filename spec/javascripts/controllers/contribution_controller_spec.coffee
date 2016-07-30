describe 'ContributionController', ->
  beforeEach module('Crowdscribed')

  longDescription = 'Aliquam egestas odio sit amet risus consectetur porttitor. Aliquam tristique hendrerit nisi sodales aliquet. Etiam.'
  httpBackend = null
  controller = null
  rootScope = null
  scope = null
  beforeEach(inject((_$rootScope_, _$controller_, _$httpBackend_) ->
    httpBackend = _$httpBackend_
    rootScope = _$rootScope_
    scope = rootScope.$new()
    controller = _$controller_ 'ContributionController',
      $scope: scope
  ))

  beforeEach ->
    httpBackend.expectGET('/campaigns/1/rewards.json').respond [
      id: 1
      campaign_id: 1
      description: 'Printed copy of the book'
      long_description: 'This is the other long description'
      minimum_contribution: 50
      physical_address_required: true
    ,
      id: 2
      campaign_id: 1
      description: 'Electronic copy of the book'
      house_reward_id: 100
      minimum_contribution: 30
      physical_address_required: false
      working_description: longDescription
    ]

  describe 'rewards', ->
    it 'is a list of available rewards for the specified campaign', ->
      scope.campaignId = 1
      scope.$digest()
      httpBackend.flush()
      rewardNames = _.map(scope.rewards, 'description')
      expect(rewardNames).toEqual [
        'Printed copy of the book'
        'Electronic copy of the book'
      ]

  describe 'selectedReward', ->
    beforeEach ->
      scope.campaignId = 1
      scope.$digest()
      httpBackend.flush()

    it 'is the reward associated with selectedRewardId', ->
      scope.selectedRewardId = 2
      scope.$digest()
      expect(scope.selectedReward).not.toBeNull()
      expect(scope.selectedReward['description']).toEqual 'Electronic copy of the book'
      expect(scope.selectedReward['working_description']).toEqual longDescription

  describe 'clearSelection', ->
    beforeEach ->
      scope.campaignId = 1
      scope.$digest()
      httpBackend.flush()

    it 'unselects the selected reward', ->
      expect(scope.selectedRewardId).not.toBeNull()
      scope.clearSelection()
      expect(scope.selectedRewardId).toBeNull()

  describe 'customContributionAmount', ->
    beforeEach ->
      scope.campaignId = 1
      scope.$digest()
      httpBackend.flush()

    describe 'when changed', ->
      it 'populates $scope.availableRewards with the rewards that have a minimum donation less than or equal to the custom donation amount', ->
        scope.selectedRewardId = null
        scope.customContributionAmount = 10
        scope.$apply()
        expect(scope.availableRewards.map((r) -> r.description)).toEqual []

        scope.customContributionAmount = 30
        scope.$apply()
        expect(scope.availableRewards.map((r) -> r.description)).toEqual ['Electronic copy of the book']

        scope.customContributionAmount = 50
        scope.$apply()
        expect(scope.availableRewards.map((r) -> r.description)).toEqual ['Printed copy of the book', 'Electronic copy of the book']

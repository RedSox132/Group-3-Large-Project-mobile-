import React, { Component, useState } from 'react';
import { TextInput, Button, View, Text } from 'react-native';

export default class HomeScreen extends Component {
  constructor() {
    super();
    this.state = {
      searchCriteria: '\n',
      newCard: '\n',
    };
  }

<Button
  title="View Saved Routines"
  onPress={() => this.props.navigation.navigate('ViewSavedRoutines')}
/>

<Button
  title="Add Routine"
  onPress={() => this.props.navigation.navigate('AddRoutineScreen')}
/>
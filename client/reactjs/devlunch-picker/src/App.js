import React, { Component } from 'react';
import './App.css';
import Header from './Header.js';
import LoginForm from './LoginForm.js'
import SignupForm from './SignupForm.js';
import Timer from './Timer.js';

/**
 * data-deps:
 * - value to display
 */
class UserList extends Component {
  render() {
    // If there are no users, dont make a list
    if (this.props.users.length === 0) {
      return (
        <div className="user-list_empty">
        </div>
      )
    }

    const what = this.props.what.charAt(0).toUpperCase() + this.props.what.slice(1)
    return (
      <div className="user-list">
        <div className="user-list_header">
          {what}
        </div>
        <ul className="user-list_list">
          {this.props.users.map( (user) => {
            return <li key={user.nickname} className="user-list_user">{user.nickname}</li>
          })}
        </ul>
      </div>
    )
  }
}

class User {
  constructor (name, nickname, id, status = NOT_COMING, pick = "") {
    this.name = name
    this.nickname = nickname || name
    this.id = id
    this.status = status
    this.pick = pick
  }

  static statusFromString (status) {
    if (status === 'voting') {
      return VOTING
    }
    else if (status === 'joining') {
      return JOINING
    }
    else {
      return NOT_COMING
    }
  }
}

function getFakeUsers() {
  return [
    new User("USING FAKE USERS", 0, VOTING, "", ""),
    new User("foo", 0, VOTING, "", ""),
    new User("bar", 0, VOTING, "", ""),
    new User("baz", 0, VOTING, "", ""),
    new User("bin", 0, JOINING, "", ""),
    new User("etc", 0, JOINING, "", ""),
    new User("dev", 0, JOINING, "", ""),
    new User("home", 0, NOT_COMING, "", ""),
    new User("root", 0, NOT_COMING, "", ""),
  ];
}

class App extends Component {
  constructor(props) {
    super(props);

    this.state = {
      sessionId: undefined,
      currentUser: "tester",
      allUsers: [],
    }
  }

  // TODO FIXME all this data needs to come in in the right format
  static getRealUsers() {

    let options = {
      method: 'GET',
    }

    // success of request, now get the data out
    let fetchSuccess = response => {
      return response.json()
    }

    // failure of request
    let fetchError = error => {
      console.log("there was an error in requesting data from the server. Is it running, and is your cross-origin shit sorted?")
      console.log(error)
    }

    //success of from json
    let decodeSuccess = data => {
      return data.map(user => {
        Object.setPrototypeOf(user, User.prototype)
        user.status = User.statusFromString(user.status)
        return user
      })
    }

    let decodeError = error => {
      console.error("You've probably got some invalid JSON coming back from the server. Write better unit test, nerd.")
      return getFakeUsers();
    }

    // let response = fetch('http://localhost:4567/users', options);
    // let result = response.then(fetchSuccess, fetchError);
    // return result.then(decodeSuccess, decodeError)
    return (
      fetch('http://localhost:4567/users', options)
      .then(fetchSuccess, fetchError)
      .then(decodeSuccess, decodeError)
    );
  }

  componentDidMount() {
    //fetch all our data here!
    App.getRealUsers().then(users => {
      this.setState({
        allUsers: users
      })
    })
  }

  render() {
    const voting = this.state.allUsers.filter( (user) => {
      return user.status === VOTING
    });
    const joining = this.state.allUsers.filter( (user) => {
      return user.status === JOINING
    });
    return (
      <div className="App">
        <LoginForm />
        <Header />
        <SignupForm />
        <UserList what="voting" users={voting} />
        <UserList what="joining" users={joining} />
      </div>
    );
  }
}

export default App;

import React, { Component } from 'react';
import './App.css';

/**
 * data-deps:
 * - app-state
 */
class Header extends Component {
  render() {
    return (
      <div class="header">
        {/* should say different things depending on app state */}
        <div class="header_label">Time left: </div>
        <Timer />
      </div>
    );
  }
}

/**
 * data-deps:
 * - app-state: time of next state change
 */
class Timer extends Component {
  render() {
    return (
      <div class="timer">
        {/* TODO get data from app state or something */}
        unknown
      </div>
    )
  }
}

/**
 * data-deps:
 * - callbacks to update state
 */
class SignupForm extends Component {
  render() {
    return (
      <div class="signup-form">
        <input class="signup-form_nickname" placeholder="nickname"/>
        <input class="signup-form_pick" placeholder="pick"/>
        <button class="signup-form_minus">-</button>
        <button class="signup-form_tilde">~</button>
        <button class="signup-form_plus">+</button>
      </div>
    )
  }
}

/**
 * data-deps:
 * - value to display
 */
class UserList extends Component {
  render() {
    return (
      <div class="user-list">
        {this.props.what}
        <ul>
          {this.props.users.map( (user) => {
            return <li class="user-list_user">{user.nickname}</li>
          })}
        </ul>
      </div>
    )
  }
}

const NOT_COMING = 0,
      JOINING = 1,
      VOTING = 2;

function makeUser(nickname, status) {
  return {
    nickname: nickname,
    status: status
  }
}

function getSampleUsers() {
  return [
    makeUser("foo", VOTING),
    makeUser("bar", VOTING),
    makeUser("baz", VOTING),
    makeUser("usr", JOINING),
    makeUser("etc", JOINING),
    makeUser("tmp", JOINING),
    makeUser("home", NOT_COMING),
    makeUser("root", NOT_COMING)
  ];
}

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      allUsers: getSampleUsers()
    }
  }

  render() {
    let voting = this.state.allUsers.filter( (user) => {
      return user.status === VOTING
    });
    let joining = this.state.allUsers.filter( (user) => {
      return user.status === JOINING
    });
    return (
      <div className="App">
        <Header />
        <SignupForm />
        <UserList what="voting" users={voting} />
        <UserList what="joining" users={joining}/>
      </div>
    );
  }
}

export default App;

import React, { Component } from 'react';
import './App.css';

/**
 * data-deps:
 * - app-state
 */
class Header extends Component {
  render() {
    return (
      <div className="header">
        {/* should say different things depending on app state */}
        <div className="header_label">Time left: </div>
        <Timer />
      </div>
    );
  }
}

class LoginForm extends Component {
  render() {
    return(
      <div classname="login-form">
        <form>
          <input placeholder="username"/>
        </form>
      </div>
    )
  }
}

/**
 * data-deps:
 * - app-state: time of next state change
 */
class Timer extends Component {
  render() {
    return (
      <div className="timer">
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
  constructor(props) {
    super(props)

    //form data to submit
    this.state = {
      formParams:
        {
          "nickname": "",
          "pick": "",
        }
    }
    
    this.handleSubmit = this.handleSubmit.bind(this)
    this.handleChange = this.handleChange.bind(this)
  }

  handleSubmit(event) {
    event.preventDefault()
    alert(
      "submitting as " + this.state.action + " with data\n" +
      "this.state.nickname: " + this.state.nickname + "\n" +
      "this.state.pick: " + this.state.pick
    )
    /*TODO: something like:
     * POST(session, data)
     */
  }

  handleChange(event) {
    let key = event.target.name,
        value = event.target.value;
    
    this.setState(
      {[key]: value}
    );
  }

  setAction(which) {
    this.setState({action: which})
  }

  render() {
    return (
      <div className="signup-form">
        <form className="signup-form_form" onSubmit={this.handleSubmit}>
          {
            Object.keys(this.state.formParams).map( key => {
              return (
                <input name={key} className={'signup-form_form_' + key} placeholder={key} onChange={this.handleChange} />
              )
            })
          }
          <div className="signup-form_buttons">
            <button type="submit" className="signup-form_buttons_minus" onClick={() => this.setAction(NOT_COMING)}>-</button>
            <button type="submit" className="signup-form_buttons_tilde" onClick={() => this.setAction(JOINING)}>~</button>
            <button type="submit" className="signup-form_buttons_plus" onClick={() => this.setAction(VOTING)}>+</button>   
          </div>
        </form>
      </div>
    )
  }
} /* SignupForm */

/**
 * data-deps:
 * - value to display
 */
class UserList extends Component {
  render() {
    // If there are no users, dont make a list
    if (this.props.users.length === 0) {
      return (
        <div classname="user-list_empty">
        </div>
      )
    }

    let what = this.props.what.charAt(0).toUpperCase() + this.props.what.slice(1)
    return (
      <div className="user-list">
        <div className="user-list_header">
          {what}
        </div>
        <ul className="user-list_list">
          {this.props.users.map( (user) => {
            return <li className="user-list_user">{user.nickname}</li>
          })}
        </ul>
      </div>
    )
  }
}

const NOT_COMING = 0
const JOINING = 1
const VOTING = 2

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
      currentUser: "tester",
      allUsers: [],
    }
  }

  // TODO FIXME all this data needs to come in in the right format
  static getRealUsers() {
    return fetch('http://localhost:4567/users', {
      method: 'GET',
    }).then( response => { //success
      return response.json()
    }, error => { //failure
      console.log("there was an error")
      console.log(error)
    }).then( data => { //success
      return data.map(user => {
        Object.setPrototypeOf(user, User.prototype)
        user.status = User.statusFromString(user.status)
        return user
      }, error => { //failure
        return getFakeUsers();
      })
    })
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
    let voting = this.state.allUsers.filter( (user) => {
      return user.status === VOTING
    });
    let joining = this.state.allUsers.filter( (user) => {
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

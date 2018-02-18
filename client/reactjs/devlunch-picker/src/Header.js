import React, { Component } from 'react';
import Timer from './Timer.js';

/**
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

export default Header;
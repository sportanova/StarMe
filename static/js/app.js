var App = React.createClass({
  getInitialState: function() {
    return {
      myStarred: 'highlightMenu',
      myRepos: ''
    }
  },
  highlight: function(className) {
    if(className === 'myStarred') {
      this.setState({myStarred: 'highlightMenu', toStar: '', 'myRepos': '', iStarred: ''})
    }
    else if(className === 'myRepos') {
      this.setState({myStarred: '', toStar: '', 'myRepos': 'highlightMenu', iStarred: ''})
    }
  },
  render: function() {
    var myStarredShowHideStyle = {};
    if(!this.state.myStarred.length) {
      myStarredShowHideStyle = {display: 'none'};
    }
    else {
      myStarredShowHideStyle = {};
    }

    var myReposShowHideStyle = {};
    if(!this.state.myRepos.length) {
      myReposShowHideStyle = {display: 'none'};
    }
    else {
      myReposShowHideStyle = {};
    }

    var cx = React.addons.classSet;
    var menuClasses = cx({
      'pure-menu ': true,
      'pure-menu-open': true,
      'pure-menu-horizontal': true
    });

    return (
      <div>
        <div className={menuClasses}>
          <ul>
            <li><a className={this.state.myStarred} onClick={this.highlight.bind(this, 'myStarred')} href="#">My Starred Repos</a></li>
            <li><a className={this.state.myRepos} onClick={this.highlight.bind(this, 'myRepos')} href="#">All My Repos</a></li>
          </ul>
        </div>
        <Repos repoType='selected' username={this.props.username} showRepos={myStarredShowHideStyle}/>
        <Repos repoType='public' username={this.props.username} showRepos={myReposShowHideStyle}/>
      </div>
    );
  }
});

function StarMe() {
}

StarMe.prototype.init = function(domNode, attrs) {
  this.react = React.render(<App username={attrs.username}/>, domNode);
  return this.react;
};

StarMe.prototype.setState = function(attrs) {
  this.react.setState(attrs);
};
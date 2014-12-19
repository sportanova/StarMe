var Repo = React.createClass({
  getInitialState: function() {
    return {
      repo: this.props.data
    }
  },
  toggleRepos: function(e) {
    var isChecked = e.target.checked;

    if(this.props.repoType === 'public' && isChecked) {
      var event = new CustomEvent('addSelectedRepo', { 'detail': this.state.repo });
      document.body.dispatchEvent(event);

      this.props.removeRepo(this.props.index);
    }
    else if(this.props.repoType === 'selected' && !isChecked) {
      var event = new CustomEvent('addPublicRepo', { 'detail': this.state.repo });
      document.body.dispatchEvent(event);

      this.props.removeRepo(this.props.index);
    }
  },
  isSelectedRepo: function(repo, repoType) {
    if(repoType === 'selected') {
      return true;
    }
  },
  render: function() {
    return (
      <div>
        <span>{this.props.data.name}</span>
          <label>
            <input onClick={this.toggleRepos} checked={this.isSelectedRepo(this.state.repo, this.props.repoType)} type="checkbox"/>
          </label>
      </div>
    );
  }
});
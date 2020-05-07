import gql from 'graphql-tag'

export default {
  async setToken(): Promise<void> {
    const { data } = await this.authenticateUser()
    localStorage.setItem('access', data.authenticateUser.access)
    localStorage.setItem('accessExpiresAt', data.authenticateUser.accessExpiresAt)
  },
  async authenticateUser(): Promise<Object> {
    return this.$apollo.mutate({
      mutation: gql`mutation authenticateUser ($email: String!, $password: String!) {
        authenticateUser(input: { email: $email, password: $password }) {
          access
          accessExpiresAt
        }
      }`,
      variables: {
        email: this.user.email,
        password: this.user.password,
      },
    })
  },
  isAuthenticated(): Boolean {
    const access = localStorage.getItem('access')
    const accessExpiresAt = Date.parse(localStorage.getItem('accessExpiresAt'))
    return access && (accessExpiresAt > Date.now())
  },
}

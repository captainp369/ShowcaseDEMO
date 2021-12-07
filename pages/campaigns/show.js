import React, { Component } from 'react';
import { Card } from 'semantic-ui-react';
import Layout from '../../components/Layout';
import Campaign from '../../ethereum/campaign';
import web3 from '../../ethereum/web3';

class CampaignShow extends Component {
    static async getInitialProps(props) {
        const campaign = Campaign(props.query.address);
        
        const summary = await campaign.methods.getSummary().call();

        return {
            minimumContribution: summary[0],
            balance: summary[1],
            requestsCount: summary[2],
            approversCount: summary[3],
            manager: summary[4]
        };
    }

    renderCards() {
        const {
            balance,
            manager,
            minimumContribution,
            requestsCount,
            approversCount
        } = this.props;

        const items = [
            {
                header: manager,
                meta: 'Address of Manager',
                description: 'The manager created this campaign and can create requests to withdraw money',
                style: { overflowWrap: 'break-word' }
            },
            {
                header: minimumContribution,
                meta: 'minimum contribution (wei)',
                description: 'contribute to become an approver',
                style: { overflowWrap: 'break-word' }
            },
            {
                header: requestsCount,
                meta: 'Number of Requests',
                description: 'request tries to withdraw money from the contract, requests must be approved by approvers',
                style: { overflowWrap: 'break-word' }
            },
            {
                header: approversCount,
                meta: 'Number of Approvers',
                description: 'numbers of people who have already donated to the project',
                style: { overflowWrap: 'break-word' }
            },
            {
                header: web3.utils.fromWei(balance,'ether'),
                meta: 'Campaign Balance (ether)',
                description: 'how much money this campaign has left to spend'
            }
        ];

        return <Card.Group items={items} />;
    }

    render() {
        return (
            <Layout>
                <h3>Campaign Show</h3>
                {this.renderCards()}
            </Layout>
        );
    }
}

export default CampaignShow;
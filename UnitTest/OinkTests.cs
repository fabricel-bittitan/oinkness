using System;

using NUnit.Framework;

using JenkinsTest;

namespace UnitTest
{
    [TestFixture]
    [Category("JenkinsTest.Oink")]
    class OinkTests
    {
        [Test]
        public void Should_Success_CreateOink()
        {
            // Arrange
            Oink oink = new Oink();
            // Act
            // Assert
        }
    }
}
